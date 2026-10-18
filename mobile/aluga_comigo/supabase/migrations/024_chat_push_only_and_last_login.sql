-- Chat: push FCM direto (sem user_notifications). Conta: último login.

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

ALTER TABLE public.accounts
  ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMPTZ;

CREATE OR REPLACE FUNCTION public.record_last_login()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN;
  END IF;

  UPDATE public.accounts
  SET last_login_at = NOW()
  WHERE id = auth.uid();
END;
$$;

GRANT EXECUTE ON FUNCTION public.record_last_login() TO authenticated;

CREATE OR REPLACE FUNCTION public.send_chat_push(
  p_account_id UUID,
  p_title TEXT,
  p_body TEXT,
  p_reference_id UUID DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_base_url TEXT;
  v_secret TEXT;
  v_url TEXT;
BEGIN
  IF p_account_id IS NULL THEN
    RETURN;
  END IF;

  v_base_url := nullif(trim(current_setting('app.settings.supabase_url', true)), '');
  v_secret := nullif(trim(current_setting('app.settings.push_webhook_secret', true)), '');

  IF v_base_url IS NULL OR v_secret IS NULL THEN
    RETURN;
  END IF;

  v_url := rtrim(v_base_url, '/') || '/functions/v1/send-chat-push';

  PERFORM net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-push-webhook-secret', v_secret
    ),
    body := jsonb_build_object(
      'account_id', p_account_id,
      'title', COALESCE(p_title, 'Nova mensagem'),
      'body', COALESCE(p_body, ''),
      'reference_id', p_reference_id
    )
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
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

  PERFORM public.send_chat_push(
    v_recipient_id,
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

  PERFORM public.send_chat_push(
    v_recipient_id,
    v_sender_name,
    LEFT(COALESCE(NEW.content, ''), 200),
    NEW.chat_id
  );

  RETURN NEW;
END;
$$;
