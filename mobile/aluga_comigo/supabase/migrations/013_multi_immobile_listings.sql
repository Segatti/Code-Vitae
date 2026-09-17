-- Vários anúncios por conta imóvel (owner_account_id); id deixa de ser só auth.uid().

ALTER TABLE public.immobiles
  ADD COLUMN IF NOT EXISTS owner_account_id UUID REFERENCES public.accounts(id) ON DELETE CASCADE;

UPDATE public.immobiles
SET owner_account_id = id
WHERE owner_account_id IS NULL;

ALTER TABLE public.immobiles
  ALTER COLUMN owner_account_id SET NOT NULL;

ALTER TABLE public.immobiles
  DROP CONSTRAINT IF EXISTS immobiles_id_fkey;

ALTER TABLE public.immobiles
  ALTER COLUMN id SET DEFAULT gen_random_uuid();

CREATE INDEX IF NOT EXISTS idx_immobiles_owner_account
  ON public.immobiles(owner_account_id, created_at DESC);

DROP POLICY IF EXISTS immobiles_select ON public.immobiles;
CREATE POLICY immobiles_select
  ON public.immobiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.accounts a
      WHERE a.id = immobiles.owner_account_id
        AND (a.is_active = TRUE OR a.id = auth.uid())
    )
    OR immobiles.owner_account_id = auth.uid()
  );

DROP POLICY IF EXISTS immobiles_insert_own ON public.immobiles;
CREATE POLICY immobiles_insert_own
  ON public.immobiles FOR INSERT
  TO authenticated
  WITH CHECK (owner_account_id = auth.uid());

DROP POLICY IF EXISTS immobiles_update_own ON public.immobiles;
CREATE POLICY immobiles_update_own
  ON public.immobiles FOR UPDATE
  TO authenticated
  USING (owner_account_id = auth.uid());

DROP POLICY IF EXISTS immobile_matches_all_own ON public.immobile_matches;
CREATE POLICY immobile_matches_all_own
  ON public.immobile_matches FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.immobiles i
      WHERE i.id = immobile_matches.immobile_id
        AND i.owner_account_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.immobiles i
      WHERE i.id = immobile_matches.immobile_id
        AND i.owner_account_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS person_matches_select_received ON public.person_matches;
CREATE POLICY person_matches_select_received
  ON public.person_matches FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.immobiles i
      WHERE i.id = person_matches.immobile_id
        AND i.owner_account_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS chats_select_participant ON public.chats;
CREATE POLICY chats_select_participant
  ON public.chats FOR SELECT
  TO authenticated
  USING (
    person_id = auth.uid()
    OR immobile_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.immobiles i
      WHERE i.id = chats.immobile_id
        AND i.owner_account_id = auth.uid()
    )
  );

CREATE OR REPLACE FUNCTION public.immobile_owned_by_auth(p_immobile_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.immobiles i
    WHERE i.id = p_immobile_id
      AND i.owner_account_id = auth.uid()
  );
$$;

GRANT EXECUTE ON FUNCTION public.immobile_owned_by_auth(UUID) TO authenticated;

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

  IF auth.uid() <> p_person_id
     AND auth.uid() <> p_immobile_id
     AND NOT public.immobile_owned_by_auth(p_immobile_id) THEN
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
