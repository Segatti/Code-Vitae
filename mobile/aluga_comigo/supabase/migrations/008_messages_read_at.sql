ALTER TABLE public.messages
  ADD COLUMN IF NOT EXISTS read_at TIMESTAMPTZ;

CREATE OR REPLACE FUNCTION public.mark_chat_messages_read(p_chat_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.chats c
    WHERE c.id = p_chat_id
      AND (c.person_id = auth.uid() OR c.immobile_id = auth.uid())
  ) THEN
    RAISE EXCEPTION 'chat not found';
  END IF;

  UPDATE public.messages
  SET read_at = NOW()
  WHERE chat_id = p_chat_id
    AND sender_id <> auth.uid()
    AND read_at IS NULL;
END;
$$;

GRANT EXECUTE ON FUNCTION public.mark_chat_messages_read(UUID) TO authenticated;
