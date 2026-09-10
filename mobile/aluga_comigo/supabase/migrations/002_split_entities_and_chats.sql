-- Aluga Comigo — reestruturação: accounts, persons, immobiles, matches, chats, messages

DROP POLICY IF EXISTS matches_all_own ON public.matches;
DROP POLICY IF EXISTS profiles_update_own ON public.profiles;
DROP POLICY IF EXISTS profiles_insert_own ON public.profiles;
DROP POLICY IF EXISTS profiles_select_active ON public.profiles;

DROP TABLE IF EXISTS public.matches CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

CREATE TABLE public.accounts (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  type_user TEXT NOT NULL CHECK (type_user IN ('person', 'immobile')),
  phone TEXT NOT NULL DEFAULT '',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.persons (
  id UUID PRIMARY KEY REFERENCES public.accounts(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT '',
  state TEXT NOT NULL DEFAULT '',
  city TEXT NOT NULL DEFAULT '',
  photos TEXT[] NOT NULL DEFAULT '{}',
  short_description TEXT NOT NULL DEFAULT '',
  long_description TEXT NOT NULL DEFAULT '',
  score DOUBLE PRECISION NOT NULL DEFAULT 0,
  skills TEXT[] NOT NULL DEFAULT '{}',
  date_birth TEXT NOT NULL DEFAULT '',
  price_max_immobile DOUBLE PRECISION NOT NULL DEFAULT 0,
  desired_immobile TEXT NOT NULL DEFAULT 'none',
  life_style TEXT NOT NULL DEFAULT 'none',
  gender TEXT NOT NULL DEFAULT '',
  houseworks TEXT[] NOT NULL DEFAULT '{}',
  last_match_immobile_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.immobiles (
  id UUID PRIMARY KEY REFERENCES public.accounts(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT '',
  state TEXT NOT NULL DEFAULT '',
  city TEXT NOT NULL DEFAULT '',
  cep TEXT NOT NULL DEFAULT '',
  photos TEXT[] NOT NULL DEFAULT '{}',
  short_description TEXT NOT NULL DEFAULT '',
  long_description TEXT NOT NULL DEFAULT '',
  score DOUBLE PRECISION NOT NULL DEFAULT 0,
  price DOUBLE PRECISION NOT NULL DEFAULT 0,
  type_immobile TEXT NOT NULL DEFAULT 'none',
  bathrooms INTEGER NOT NULL DEFAULT 0,
  bedrooms INTEGER NOT NULL DEFAULT 0,
  car_spaces INTEGER NOT NULL DEFAULT 0,
  is_market_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_school_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_hospital_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_park_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_gym_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_mall_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_beach_near BOOLEAN NOT NULL DEFAULT FALSE,
  last_match_person_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.persons
  ADD CONSTRAINT persons_last_match_immobile_fk
  FOREIGN KEY (last_match_immobile_id) REFERENCES public.immobiles(id);

ALTER TABLE public.immobiles
  ADD CONSTRAINT immobiles_last_match_person_fk
  FOREIGN KEY (last_match_person_id) REFERENCES public.persons(id);

CREATE TABLE public.person_matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  person_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  immobile_id UUID NOT NULL REFERENCES public.immobiles(id) ON DELETE CASCADE,
  match_type TEXT NOT NULL CHECK (match_type IN ('like', 'favorite', 'unlike', 'none')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (person_id, immobile_id)
);

CREATE TABLE public.immobile_matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  immobile_id UUID NOT NULL REFERENCES public.immobiles(id) ON DELETE CASCADE,
  person_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  match_type TEXT NOT NULL CHECK (match_type IN ('like', 'favorite', 'unlike', 'none')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (immobile_id, person_id)
);

CREATE TABLE public.chats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  person_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  immobile_id UUID NOT NULL REFERENCES public.immobiles(id) ON DELETE CASCADE,
  person_name TEXT NOT NULL DEFAULT '',
  person_photo TEXT NOT NULL DEFAULT '',
  immobile_name TEXT NOT NULL DEFAULT '',
  immobile_photo TEXT NOT NULL DEFAULT '',
  last_message_preview TEXT NOT NULL DEFAULT '',
  last_message_at TIMESTAMPTZ,
  last_message_sender_id UUID REFERENCES public.accounts(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (person_id, immobile_id)
);

CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chat_id UUID NOT NULL REFERENCES public.chats(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  content TEXT NOT NULL DEFAULT '',
  message_type TEXT NOT NULL DEFAULT 'text',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_accounts_type_user ON public.accounts(type_user);
CREATE INDEX idx_accounts_is_active ON public.accounts(is_active);
CREATE INDEX idx_persons_created_at ON public.persons(created_at DESC);
CREATE INDEX idx_immobiles_created_at ON public.immobiles(created_at DESC);
CREATE INDEX idx_person_matches_person ON public.person_matches(person_id);
CREATE INDEX idx_immobile_matches_immobile ON public.immobile_matches(immobile_id);
CREATE INDEX idx_chats_person ON public.chats(person_id);
CREATE INDEX idx_chats_immobile ON public.chats(immobile_id);
CREATE INDEX idx_chats_last_message_at ON public.chats(last_message_at DESC NULLS LAST);
CREATE INDEX idx_messages_chat_created ON public.messages(chat_id, created_at);

ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.persons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.immobiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.person_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.immobile_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY accounts_select
  ON public.accounts FOR SELECT
  TO authenticated
  USING (is_active = TRUE OR auth.uid() = id);

CREATE POLICY accounts_insert_own
  ON public.accounts FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY accounts_update_own
  ON public.accounts FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY persons_select
  ON public.persons FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.accounts a
      WHERE a.id = persons.id AND (a.is_active = TRUE OR a.id = auth.uid())
    )
  );

CREATE POLICY persons_insert_own
  ON public.persons FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY persons_update_own
  ON public.persons FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY immobiles_select
  ON public.immobiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.accounts a
      WHERE a.id = immobiles.id AND (a.is_active = TRUE OR a.id = auth.uid())
    )
  );

CREATE POLICY immobiles_insert_own
  ON public.immobiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY immobiles_update_own
  ON public.immobiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY person_matches_all_own
  ON public.person_matches FOR ALL
  TO authenticated
  USING (person_id = auth.uid())
  WITH CHECK (person_id = auth.uid());

CREATE POLICY immobile_matches_all_own
  ON public.immobile_matches FOR ALL
  TO authenticated
  USING (immobile_id = auth.uid())
  WITH CHECK (immobile_id = auth.uid());

CREATE POLICY chats_select_participant
  ON public.chats FOR SELECT
  TO authenticated
  USING (person_id = auth.uid() OR immobile_id = auth.uid());

CREATE POLICY messages_select_participant
  ON public.messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = messages.chat_id
        AND (c.person_id = auth.uid() OR c.immobile_id = auth.uid())
    )
  );

CREATE POLICY messages_insert_participant
  ON public.messages FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = messages.chat_id
        AND (c.person_id = auth.uid() OR c.immobile_id = auth.uid())
    )
  );

-- Match mútuo → cria chat
CREATE OR REPLACE FUNCTION public.try_create_chat_on_mutual_match(
  p_person_id UUID,
  p_immobile_id UUID
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_person_like BOOLEAN;
  v_immobile_like BOOLEAN;
  v_person_name TEXT;
  v_person_photo TEXT;
  v_immobile_name TEXT;
  v_immobile_photo TEXT;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM public.person_matches
    WHERE person_id = p_person_id
      AND immobile_id = p_immobile_id
      AND match_type IN ('like', 'favorite')
  ) INTO v_person_like;

  SELECT EXISTS (
    SELECT 1 FROM public.immobile_matches
    WHERE immobile_id = p_immobile_id
      AND person_id = p_person_id
      AND match_type IN ('like', 'favorite')
  ) INTO v_immobile_like;

  IF NOT (v_person_like AND v_immobile_like) THEN
    RETURN;
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
END;
$$;

CREATE OR REPLACE FUNCTION public.on_person_match_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.match_type IN ('like', 'favorite') THEN
    PERFORM public.try_create_chat_on_mutual_match(NEW.person_id, NEW.immobile_id);
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.on_immobile_match_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.match_type IN ('like', 'favorite') THEN
    PERFORM public.try_create_chat_on_mutual_match(NEW.person_id, NEW.immobile_id);
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_person_match_mutual
  AFTER INSERT OR UPDATE OF match_type ON public.person_matches
  FOR EACH ROW
  EXECUTE FUNCTION public.on_person_match_insert();

CREATE TRIGGER trg_immobile_match_mutual
  AFTER INSERT OR UPDATE OF match_type ON public.immobile_matches
  FOR EACH ROW
  EXECUTE FUNCTION public.on_immobile_match_insert();

-- Atualiza header do chat ao inserir mensagem
CREATE OR REPLACE FUNCTION public.on_message_insert_update_chat()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.chats
  SET
    last_message_preview = LEFT(NEW.content, 200),
    last_message_at = NEW.created_at,
    last_message_sender_id = NEW.sender_id
  WHERE id = NEW.chat_id;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_message_update_chat
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.on_message_insert_update_chat();
