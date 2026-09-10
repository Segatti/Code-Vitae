-- Permite ler curtidas/super stars recebidos (além dos enviados pelo próprio usuário)

CREATE POLICY person_matches_select_received
  ON public.person_matches FOR SELECT
  TO authenticated
  USING (immobile_id = auth.uid());

CREATE POLICY immobile_matches_select_received
  ON public.immobile_matches FOR SELECT
  TO authenticated
  USING (person_id = auth.uid());

CREATE INDEX IF NOT EXISTS idx_person_matches_immobile
  ON public.person_matches(immobile_id);

CREATE INDEX IF NOT EXISTS idx_immobile_matches_person
  ON public.immobile_matches(person_id);
