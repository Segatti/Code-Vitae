-- Dono do anúncio (owner_account_id) acessa mensagens quando immobile_id é o listing.

DROP POLICY IF EXISTS messages_select_participant ON public.messages;
CREATE POLICY messages_select_participant
  ON public.messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = messages.chat_id
        AND (
          c.person_id = auth.uid()
          OR c.immobile_id = auth.uid()
          OR public.immobile_owned_by_auth(c.immobile_id)
        )
    )
  );

DROP POLICY IF EXISTS messages_insert_participant ON public.messages;
CREATE POLICY messages_insert_participant
  ON public.messages FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = messages.chat_id
        AND (
          c.person_id = auth.uid()
          OR c.immobile_id = auth.uid()
          OR public.immobile_owned_by_auth(c.immobile_id)
        )
    )
  );

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

  IF EXISTS (
    SELECT 1 FROM public.chats c
    WHERE c.id = p_chat_id
      AND (
        c.person_id = auth.uid()
        OR c.immobile_id = auth.uid()
        OR public.immobile_owned_by_auth(c.immobile_id)
      )
  ) THEN
    UPDATE public.messages
    SET read_at = NOW()
    WHERE chat_id = p_chat_id
      AND sender_id <> auth.uid()
      AND read_at IS NULL;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.person_peer_chats c
    WHERE c.id = p_chat_id
      AND (c.person_low_id = auth.uid() OR c.person_high_id = auth.uid())
  ) THEN
    UPDATE public.person_peer_messages
    SET read_at = NOW()
    WHERE chat_id = p_chat_id
      AND sender_id <> auth.uid()
      AND read_at IS NULL;
    RETURN;
  END IF;

  RAISE EXCEPTION 'chat not found';
END;
$$;

GRANT EXECUTE ON FUNCTION public.mark_chat_messages_read(UUID) TO authenticated;

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
      AND (
        c.person_id = auth.uid()
        OR c.immobile_id = auth.uid()
        OR public.immobile_owned_by_auth(c.immobile_id)
      )
  ) THEN
    RAISE EXCEPTION 'chat not found';
  END IF;

  DELETE FROM public.messages WHERE chat_id = p_chat_id;
  DELETE FROM public.chats WHERE id = p_chat_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.delete_chat_for_user(UUID, BOOLEAN) TO authenticated;
