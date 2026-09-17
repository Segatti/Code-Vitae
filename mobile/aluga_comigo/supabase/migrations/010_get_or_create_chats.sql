-- Chats pessoa↔pessoa + RPC get-or-create para abrir conversa a partir de contatos

CREATE TABLE IF NOT EXISTS public.person_peer_chats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  person_low_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  person_high_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  person_low_name TEXT NOT NULL DEFAULT '',
  person_low_photo TEXT NOT NULL DEFAULT '',
  person_high_name TEXT NOT NULL DEFAULT '',
  person_high_photo TEXT NOT NULL DEFAULT '',
  last_message_preview TEXT NOT NULL DEFAULT '',
  last_message_at TIMESTAMPTZ,
  last_message_sender_id UUID REFERENCES public.accounts(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (person_low_id, person_high_id),
  CHECK (person_low_id < person_high_id)
);

CREATE INDEX IF NOT EXISTS idx_person_peer_chats_low
  ON public.person_peer_chats(person_low_id);
CREATE INDEX IF NOT EXISTS idx_person_peer_chats_high
  ON public.person_peer_chats(person_high_id);
CREATE INDEX IF NOT EXISTS idx_person_peer_chats_last_message_at
  ON public.person_peer_chats(last_message_at DESC NULLS LAST);

CREATE TABLE IF NOT EXISTS public.person_peer_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chat_id UUID NOT NULL REFERENCES public.person_peer_chats(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  content TEXT NOT NULL DEFAULT '',
  message_type TEXT NOT NULL DEFAULT 'text',
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_person_peer_messages_chat_created
  ON public.person_peer_messages(chat_id, created_at);

ALTER TABLE public.person_peer_chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.person_peer_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY person_peer_chats_select_participant
  ON public.person_peer_chats FOR SELECT
  TO authenticated
  USING (
    person_low_id = auth.uid() OR person_high_id = auth.uid()
  );

CREATE POLICY person_peer_messages_select_participant
  ON public.person_peer_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.person_peer_chats c
      WHERE c.id = person_peer_messages.chat_id
        AND (c.person_low_id = auth.uid() OR c.person_high_id = auth.uid())
    )
  );

CREATE POLICY person_peer_messages_insert_participant
  ON public.person_peer_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.person_peer_chats c
      WHERE c.id = person_peer_messages.chat_id
        AND (c.person_low_id = auth.uid() OR c.person_high_id = auth.uid())
    )
  );

CREATE OR REPLACE FUNCTION public.on_person_peer_message_insert_update_chat()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.person_peer_chats
  SET
    last_message_preview = LEFT(NEW.content, 200),
    last_message_at = NEW.created_at,
    last_message_sender_id = NEW.sender_id
  WHERE id = NEW.chat_id;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_person_peer_message_update_chat ON public.person_peer_messages;
CREATE TRIGGER trg_person_peer_message_update_chat
  AFTER INSERT ON public.person_peer_messages
  FOR EACH ROW
  EXECUTE FUNCTION public.on_person_peer_message_insert_update_chat();

CREATE OR REPLACE FUNCTION public.get_or_create_person_immobile_chat(
  p_person_id UUID,
  p_immobile_id UUID
)
RETURNS public.chats
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_chat public.chats%ROWTYPE;
  v_person_name TEXT;
  v_person_photo TEXT;
  v_immobile_name TEXT;
  v_immobile_photo TEXT;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF auth.uid() <> p_person_id AND auth.uid() <> p_immobile_id THEN
    RAISE EXCEPTION 'forbidden';
  END IF;

  PERFORM public.try_create_chat_on_mutual_match(p_person_id, p_immobile_id);

  SELECT * INTO v_chat
  FROM public.chats
  WHERE person_id = p_person_id AND immobile_id = p_immobile_id;

  IF FOUND THEN
    RETURN v_chat;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.person_matches
    WHERE person_id = p_person_id
      AND immobile_id = p_immobile_id
      AND match_type IN ('like', 'favorite')
  ) AND NOT EXISTS (
    SELECT 1 FROM public.immobile_matches
    WHERE immobile_id = p_immobile_id
      AND person_id = p_person_id
      AND match_type IN ('like', 'favorite')
  ) THEN
    RAISE EXCEPTION 'no match with this contact';
  END IF;

  SELECT name, COALESCE(photos[1], '')
  INTO v_person_name, v_person_photo
  FROM public.persons WHERE id = p_person_id;

  SELECT name, COALESCE(photos[1], '')
  INTO v_immobile_name, v_immobile_photo
  FROM public.immobiles WHERE id = p_immobile_id;

  INSERT INTO public.chats (
    person_id,
    immobile_id,
    person_name,
    person_photo,
    immobile_name,
    immobile_photo
  )
  VALUES (
    p_person_id,
    p_immobile_id,
    COALESCE(v_person_name, ''),
    COALESCE(v_person_photo, ''),
    COALESCE(v_immobile_name, ''),
    COALESCE(v_immobile_photo, '')
  )
  ON CONFLICT (person_id, immobile_id) DO NOTHING;

  SELECT * INTO v_chat
  FROM public.chats
  WHERE person_id = p_person_id AND immobile_id = p_immobile_id;

  RETURN v_chat;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_or_create_person_peer_chat(
  p_other_person_id UUID
)
RETURNS public.person_peer_chats
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_self UUID := auth.uid();
  v_low UUID;
  v_high UUID;
  v_chat public.person_peer_chats%ROWTYPE;
  v_self_name TEXT;
  v_self_photo TEXT;
  v_other_name TEXT;
  v_other_photo TEXT;
BEGIN
  IF v_self IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF p_other_person_id = v_self THEN
    RAISE EXCEPTION 'invalid peer';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.person_peer_matches
    WHERE from_person_id = v_self
      AND to_person_id = p_other_person_id
      AND match_type IN ('like', 'favorite')
  ) OR NOT EXISTS (
    SELECT 1 FROM public.person_peer_matches
    WHERE from_person_id = p_other_person_id
      AND to_person_id = v_self
      AND match_type IN ('like', 'favorite')
  ) THEN
    RAISE EXCEPTION 'mutual peer match required';
  END IF;

  IF v_self < p_other_person_id THEN
    v_low := v_self;
    v_high := p_other_person_id;
  ELSE
    v_low := p_other_person_id;
    v_high := v_self;
  END IF;

  SELECT name, COALESCE(photos[1], '')
  INTO v_self_name, v_self_photo
  FROM public.persons WHERE id = v_self;

  SELECT name, COALESCE(photos[1], '')
  INTO v_other_name, v_other_photo
  FROM public.persons WHERE id = p_other_person_id;

  INSERT INTO public.person_peer_chats (
    person_low_id,
    person_high_id,
    person_low_name,
    person_low_photo,
    person_high_name,
    person_high_photo
  )
  VALUES (
    v_low,
    v_high,
    CASE WHEN v_low = v_self THEN COALESCE(v_self_name, '')
         ELSE COALESCE(v_other_name, '') END,
    CASE WHEN v_low = v_self THEN COALESCE(v_self_photo, '')
         ELSE COALESCE(v_other_photo, '') END,
    CASE WHEN v_high = v_self THEN COALESCE(v_self_name, '')
         ELSE COALESCE(v_other_name, '') END,
    CASE WHEN v_high = v_self THEN COALESCE(v_self_photo, '')
         ELSE COALESCE(v_other_photo, '') END
  )
  ON CONFLICT (person_low_id, person_high_id) DO NOTHING;

  SELECT * INTO v_chat
  FROM public.person_peer_chats
  WHERE person_low_id = v_low AND person_high_id = v_high;

  RETURN v_chat;
END;
$$;

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
      AND (c.person_id = auth.uid() OR c.immobile_id = auth.uid())
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

GRANT EXECUTE ON FUNCTION public.get_or_create_person_immobile_chat(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_or_create_person_peer_chat(UUID) TO authenticated;
