-- Match entre inquilinos (pessoa ↔ pessoa). Imóvel: reação só via person_matches (sem match mútuo automático).

ALTER TABLE public.persons
  ADD COLUMN IF NOT EXISTS last_match_person_id UUID;

ALTER TABLE public.persons
  DROP CONSTRAINT IF EXISTS persons_last_match_person_fk;

ALTER TABLE public.persons
  ADD CONSTRAINT persons_last_match_person_fk
  FOREIGN KEY (last_match_person_id) REFERENCES public.persons(id);

CREATE TABLE IF NOT EXISTS public.person_peer_matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_person_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  to_person_id UUID NOT NULL REFERENCES public.persons(id) ON DELETE CASCADE,
  match_type TEXT NOT NULL CHECK (match_type IN ('like', 'favorite', 'unlike', 'none')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (from_person_id, to_person_id),
  CHECK (from_person_id <> to_person_id)
);

CREATE INDEX IF NOT EXISTS idx_person_peer_matches_from
  ON public.person_peer_matches(from_person_id);

CREATE INDEX IF NOT EXISTS idx_person_peer_matches_to
  ON public.person_peer_matches(to_person_id);

ALTER TABLE public.person_peer_matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY person_peer_matches_all_own
  ON public.person_peer_matches FOR ALL
  TO authenticated
  USING (from_person_id = auth.uid())
  WITH CHECK (from_person_id = auth.uid());

CREATE POLICY person_peer_matches_select_received
  ON public.person_peer_matches FOR SELECT
  TO authenticated
  USING (to_person_id = auth.uid());

-- Imóvel: curtida do inquilino não abre chat sozinha; contato partindo do anunciante depois.
CREATE OR REPLACE FUNCTION public.on_person_match_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
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
  RETURN NEW;
END;
$$;
