-- Remove chat da inbox do usuário autenticado (após desfazer match).

CREATE OR REPLACE FUNCTION public.delete_chat_for_user(
  p_chat_id UUID,
  p_is_person_peer_chat BOOLEAN DEFAULT FALSE
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF p_is_person_peer_chat THEN
    IF NOT EXISTS (
      SELECT 1 FROM public.person_peer_chats c
      WHERE c.id = p_chat_id
        AND (c.person_low_id = auth.uid() OR c.person_high_id = auth.uid())
    ) THEN
      RAISE EXCEPTION 'chat not found';
    END IF;

    DELETE FROM public.person_peer_messages WHERE chat_id = p_chat_id;
    DELETE FROM public.person_peer_chats WHERE id = p_chat_id;
    RETURN;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.chats c
    WHERE c.id = p_chat_id
      AND (c.person_id = auth.uid() OR c.immobile_id = auth.uid())
  ) THEN
    RAISE EXCEPTION 'chat not found';
  END IF;

  DELETE FROM public.messages WHERE chat_id = p_chat_id;
  DELETE FROM public.chats WHERE id = p_chat_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.delete_chat_for_user(UUID, BOOLEAN) TO authenticated;
