-- Notificação in-app (e badge/push local no app) para mensagens de chat comuns.

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.user_notifications;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

ALTER TABLE public.user_notifications REPLICA IDENTITY FULL;

ALTER TABLE public.user_notifications
  DROP CONSTRAINT IF EXISTS user_notifications_notification_type_check;

ALTER TABLE public.user_notifications
  ADD CONSTRAINT user_notifications_notification_type_check
  CHECK (
    notification_type IN (
      'like',
      'superStar',
      'superChat',
      'questCompleted',
      'chatMessage'
    )
  );

CREATE OR REPLACE FUNCTION public.notify_on_person_peer_chat_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_chat public.person_peer_chats%ROWTYPE;
  v_recipient_id UUID;
  v_sender_name TEXT;
BEGIN
  IF COALESCE(NEW.message_type, 'text') <> 'text' THEN
    RETURN NEW;
  END IF;

  SELECT * INTO v_chat FROM public.person_peer_chats WHERE id = NEW.chat_id;
  IF NOT FOUND THEN
    RETURN NEW;
  END IF;

  IF NEW.sender_id = v_chat.person_low_id THEN
    v_recipient_id := v_chat.person_high_id;
  ELSE
    v_recipient_id := v_chat.person_low_id;
  END IF;

  IF v_recipient_id IS NULL OR v_recipient_id = NEW.sender_id THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(NULLIF(TRIM(name), ''), 'Alguém')
  INTO v_sender_name
  FROM public.persons
  WHERE id = NEW.sender_id;

  IF EXISTS (
    SELECT 1 FROM public.user_notifications un
    WHERE un.account_id = v_recipient_id
      AND un.notification_type = 'chatMessage'
      AND un.title = v_sender_name
      AND un.created_at > NOW() - INTERVAL '8 seconds'
  ) THEN
    RETURN NEW;
  END IF;

  PERFORM public.create_user_notification(
    v_recipient_id,
    'chatMessage',
    v_sender_name,
    LEFT(COALESCE(NEW.content, ''), 200)
  );

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_person_peer_chat_message
  ON public.person_peer_messages;
CREATE TRIGGER trg_notify_person_peer_chat_message
  AFTER INSERT ON public.person_peer_messages
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_person_peer_chat_message();

CREATE OR REPLACE FUNCTION public.notify_on_chat_message()
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
  IF COALESCE(NEW.message_type, 'text') <> 'text' THEN
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

  IF v_recipient_id IS NULL OR v_recipient_id = NEW.sender_id THEN
    RETURN NEW;
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.user_notifications un
    WHERE un.account_id = v_recipient_id
      AND un.notification_type = 'chatMessage'
      AND un.title = v_sender_name
      AND un.created_at > NOW() - INTERVAL '8 seconds'
  ) THEN
    RETURN NEW;
  END IF;

  PERFORM public.create_user_notification(
    v_recipient_id,
    'chatMessage',
    v_sender_name,
    LEFT(COALESCE(NEW.content, ''), 200)
  );

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_chat_message ON public.messages;
CREATE TRIGGER trg_notify_chat_message
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_chat_message();
