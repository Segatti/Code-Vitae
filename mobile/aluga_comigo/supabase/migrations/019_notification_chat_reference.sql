-- Vincula notificações de chatMessage ao id da conversa (deep link no app).

ALTER TABLE public.user_notifications
  ADD COLUMN IF NOT EXISTS reference_id UUID;

CREATE OR REPLACE FUNCTION public.create_user_notification(
  p_account_id UUID,
  p_type TEXT,
  p_title TEXT,
  p_body TEXT DEFAULT '',
  p_reference_id UUID DEFAULT NULL
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
    body,
    reference_id
  )
  VALUES (
    p_account_id,
    p_type,
    p_title,
    COALESCE(p_body, ''),
    p_reference_id
  );
END;
$$;

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
      AND un.reference_id = NEW.chat_id
      AND un.created_at > NOW() - INTERVAL '8 seconds'
  ) THEN
    RETURN NEW;
  END IF;

  PERFORM public.create_user_notification(
    v_recipient_id,
    'chatMessage',
    v_sender_name,
    LEFT(COALESCE(NEW.content, ''), 200),
    NEW.chat_id
  );

  RETURN NEW;
END;
$$;

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
      AND un.reference_id = NEW.chat_id
      AND un.created_at > NOW() - INTERVAL '8 seconds'
  ) THEN
    RETURN NEW;
  END IF;

  PERFORM public.create_user_notification(
    v_recipient_id,
    'chatMessage',
    v_sender_name,
    LEFT(COALESCE(NEW.content, ''), 200),
    NEW.chat_id
  );

  RETURN NEW;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_user_notification(UUID, TEXT, TEXT, TEXT, UUID)
  TO authenticated;
