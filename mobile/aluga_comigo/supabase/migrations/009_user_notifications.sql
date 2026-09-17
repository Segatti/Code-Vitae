-- Notificações in-app: curtida, Super Star, Super Chat e missão concluída.

CREATE TABLE IF NOT EXISTS public.user_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL CHECK (
    notification_type IN ('like', 'superStar', 'superChat', 'questCompleted')
  ),
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  read_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_user_notifications_account_created
  ON public.user_notifications(account_id, created_at DESC);

ALTER TABLE public.user_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_notifications_select_own
  ON public.user_notifications FOR SELECT
  TO authenticated
  USING (account_id = auth.uid());

CREATE POLICY user_notifications_update_own
  ON public.user_notifications FOR UPDATE
  TO authenticated
  USING (account_id = auth.uid())
  WITH CHECK (account_id = auth.uid());

CREATE OR REPLACE FUNCTION public.create_user_notification(
  p_account_id UUID,
  p_type TEXT,
  p_title TEXT,
  p_body TEXT DEFAULT ''
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_account_id IS NULL OR p_type IS NULL OR p_title IS NULL THEN
    RETURN;
  END IF;

  INSERT INTO public.user_notifications (
    account_id,
    notification_type,
    title,
    body
  )
  VALUES (p_account_id, p_type, p_title, COALESCE(p_body, ''));
END;
$$;

-- person ↔ person
CREATE OR REPLACE FUNCTION public.notify_on_person_peer_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_actor_name TEXT;
BEGIN
  IF NEW.match_type NOT IN ('like', 'favorite') THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' AND OLD.match_type = NEW.match_type THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(NULLIF(TRIM(name), ''), 'Alguém')
  INTO v_actor_name
  FROM public.persons
  WHERE id = NEW.from_person_id;

  IF NEW.match_type = 'like' THEN
    PERFORM public.create_user_notification(
      NEW.to_person_id,
      'like',
      v_actor_name,
      'curtiu você'
    );
  ELSE
    PERFORM public.create_user_notification(
      NEW.to_person_id,
      'superStar',
      v_actor_name,
      'deu Super Star em você'
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_person_peer_match ON public.person_peer_matches;
CREATE TRIGGER trg_notify_person_peer_match
  AFTER INSERT OR UPDATE OF match_type ON public.person_peer_matches
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_person_peer_match();

-- inquilino → imóvel
CREATE OR REPLACE FUNCTION public.notify_on_person_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_actor_name TEXT;
BEGIN
  IF NEW.match_type NOT IN ('like', 'favorite') THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' AND OLD.match_type = NEW.match_type THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(NULLIF(TRIM(name), ''), 'Alguém')
  INTO v_actor_name
  FROM public.persons
  WHERE id = NEW.person_id;

  IF NEW.match_type = 'like' THEN
    PERFORM public.create_user_notification(
      NEW.immobile_id,
      'like',
      v_actor_name,
      'curtiu seu imóvel'
    );
  ELSE
    PERFORM public.create_user_notification(
      NEW.immobile_id,
      'superChat',
      v_actor_name,
      'enviou Super Chat sobre seu imóvel'
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_person_match ON public.person_matches;
CREATE TRIGGER trg_notify_person_match
  AFTER INSERT OR UPDATE OF match_type ON public.person_matches
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_person_match();

-- imóvel → inquilino
CREATE OR REPLACE FUNCTION public.notify_on_immobile_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_actor_name TEXT;
BEGIN
  IF NEW.match_type NOT IN ('like', 'favorite') THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' AND OLD.match_type = NEW.match_type THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(
    NULLIF(TRIM(short_description), ''),
    NULLIF(TRIM(name), ''),
    'Imóvel'
  )
  INTO v_actor_name
  FROM public.immobiles
  WHERE id = NEW.immobile_id;

  IF NEW.match_type = 'like' THEN
    PERFORM public.create_user_notification(
      NEW.person_id,
      'like',
      v_actor_name,
      'curtiu você'
    );
  ELSE
    PERFORM public.create_user_notification(
      NEW.person_id,
      'superStar',
      v_actor_name,
      'deu Super Star em você'
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_immobile_match ON public.immobile_matches;
CREATE TRIGGER trg_notify_immobile_match
  AFTER INSERT OR UPDATE OF match_type ON public.immobile_matches
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_immobile_match();

-- Super Chat (mensagem destacada)
CREATE OR REPLACE FUNCTION public.notify_on_super_chat_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_chat public.chats%ROWTYPE;
  v_recipient_id UUID;
  v_sender_name TEXT;
BEGIN
  IF NEW.message_type IS DISTINCT FROM 'superChat' THEN
    RETURN NEW;
  END IF;

  SELECT * INTO v_chat FROM public.chats WHERE id = NEW.chat_id;
  IF NOT FOUND THEN
    RETURN NEW;
  END IF;

  IF NEW.sender_id = v_chat.person_id THEN
    v_recipient_id := v_chat.immobile_id;
    SELECT COALESCE(NULLIF(TRIM(name), ''), 'Alguém')
    INTO v_sender_name
    FROM public.persons
    WHERE id = NEW.sender_id;
  ELSE
    v_recipient_id := v_chat.person_id;
    SELECT COALESCE(
      NULLIF(TRIM(short_description), ''),
      NULLIF(TRIM(name), ''),
      'Imóvel'
    )
    INTO v_sender_name
    FROM public.immobiles
    WHERE id = NEW.sender_id;
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.user_notifications un
    WHERE un.account_id = v_recipient_id
      AND un.notification_type = 'superChat'
      AND un.created_at > NOW() - INTERVAL '10 seconds'
  ) THEN
    RETURN NEW;
  END IF;

  PERFORM public.create_user_notification(
    v_recipient_id,
    'superChat',
    v_sender_name,
    LEFT(COALESCE(NEW.content, ''), 200)
  );

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_super_chat_message ON public.messages;
CREATE TRIGGER trg_notify_super_chat_message
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_super_chat_message();

-- Missão concluída
CREATE OR REPLACE FUNCTION public.increment_quest_progress(p_action_type TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_quest RECORD;
  v_was_completed BOOLEAN;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN;
  END IF;

  FOR v_quest IN
    SELECT * FROM public.quest_definitions WHERE action_type = p_action_type
  LOOP
    SELECT (uqp.completed_at IS NOT NULL)
    INTO v_was_completed
    FROM public.user_quest_progress uqp
    WHERE uqp.account_id = v_user_id AND uqp.quest_id = v_quest.id;

    v_was_completed := COALESCE(v_was_completed, FALSE);

    INSERT INTO public.user_quest_progress (account_id, quest_id, progress_count)
    VALUES (v_user_id, v_quest.id, 1)
    ON CONFLICT (account_id, quest_id)
    DO UPDATE SET progress_count = public.user_quest_progress.progress_count + 1;

    UPDATE public.user_quest_progress uqp
    SET completed_at = COALESCE(uqp.completed_at, NOW())
    FROM public.quest_definitions qd
    WHERE uqp.account_id = v_user_id
      AND uqp.quest_id = v_quest.id
      AND uqp.quest_id = qd.id
      AND uqp.progress_count >= qd.target_count
      AND uqp.completed_at IS NULL;

    IF NOT v_was_completed AND EXISTS (
      SELECT 1
      FROM public.user_quest_progress uqp
      WHERE uqp.account_id = v_user_id
        AND uqp.quest_id = v_quest.id
        AND uqp.completed_at IS NOT NULL
    ) THEN
      PERFORM public.create_user_notification(
        v_user_id,
        'questCompleted',
        'Missão concluída',
        v_quest.title
      );
    END IF;
  END LOOP;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_user_notification(UUID, TEXT, TEXT, TEXT) TO authenticated;
