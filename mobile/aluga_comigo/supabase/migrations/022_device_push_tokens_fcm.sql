-- Tokens FCM por conta + disparo HTTP para Edge Function send-chat-push.

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

CREATE TABLE IF NOT EXISTS public.device_push_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  fcm_token TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('android', 'ios', 'web', 'unknown')),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (account_id, fcm_token)
);

CREATE INDEX IF NOT EXISTS idx_device_push_tokens_account
  ON public.device_push_tokens(account_id);

ALTER TABLE public.device_push_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY device_push_tokens_select_own
  ON public.device_push_tokens FOR SELECT
  TO authenticated
  USING (account_id = (SELECT auth.uid()));

CREATE POLICY device_push_tokens_insert_own
  ON public.device_push_tokens FOR INSERT
  TO authenticated
  WITH CHECK (account_id = (SELECT auth.uid()));

CREATE POLICY device_push_tokens_update_own
  ON public.device_push_tokens FOR UPDATE
  TO authenticated
  USING (account_id = (SELECT auth.uid()))
  WITH CHECK (account_id = (SELECT auth.uid()));

CREATE POLICY device_push_tokens_delete_own
  ON public.device_push_tokens FOR DELETE
  TO authenticated
  USING (account_id = (SELECT auth.uid()));

CREATE OR REPLACE FUNCTION public.upsert_device_push_token(
  p_fcm_token TEXT,
  p_platform TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_platform TEXT;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF p_fcm_token IS NULL OR trim(p_fcm_token) = '' THEN
    RETURN;
  END IF;

  v_platform := lower(trim(coalesce(p_platform, 'unknown')));
  IF v_platform NOT IN ('android', 'ios', 'web', 'unknown') THEN
    v_platform := 'unknown';
  END IF;

  INSERT INTO public.device_push_tokens (account_id, fcm_token, platform)
  VALUES (auth.uid(), trim(p_fcm_token), v_platform)
  ON CONFLICT (account_id, fcm_token)
  DO UPDATE SET
    platform = EXCLUDED.platform,
    updated_at = NOW();
END;
$$;

GRANT EXECUTE ON FUNCTION public.upsert_device_push_token(TEXT, TEXT)
  TO authenticated;

CREATE OR REPLACE FUNCTION public.enqueue_chat_push_notification()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_base_url TEXT;
  v_secret TEXT;
  v_url TEXT;
BEGIN
  IF NEW.notification_type <> 'chatMessage' THEN
    RETURN NEW;
  END IF;

  v_base_url := nullif(trim(current_setting('app.settings.supabase_url', true)), '');
  v_secret := nullif(trim(current_setting('app.settings.push_webhook_secret', true)), '');

  IF v_base_url IS NULL OR v_secret IS NULL THEN
    RETURN NEW;
  END IF;

  v_url := rtrim(v_base_url, '/') || '/functions/v1/send-chat-push';

  PERFORM net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-push-webhook-secret', v_secret
    ),
    body := jsonb_build_object(
      'account_id', NEW.account_id,
      'title', NEW.title,
      'body', NEW.body,
      'reference_id', NEW.reference_id
    )
  );

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_enqueue_chat_push ON public.user_notifications;
CREATE TRIGGER trg_enqueue_chat_push
  AFTER INSERT ON public.user_notifications
  FOR EACH ROW
  EXECUTE FUNCTION public.enqueue_chat_push_notification();
