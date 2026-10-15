-- Tickets de suporte: sugestões, bugs, reclamações e denúncias.

CREATE TABLE IF NOT EXISTS public.support_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  title TEXT NOT NULL CHECK (char_length(trim(title)) >= 3),
  category TEXT NOT NULL CHECK (
    category IN ('suggestion', 'bug', 'complaint', 'report')
  ),
  description TEXT NOT NULL CHECK (char_length(trim(description)) >= 10),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_support_tickets_account_created
  ON public.support_tickets(account_id, created_at DESC);

ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;

CREATE POLICY support_tickets_select_own
  ON public.support_tickets FOR SELECT
  TO authenticated
  USING (account_id = auth.uid());

CREATE POLICY support_tickets_insert_own
  ON public.support_tickets FOR INSERT
  TO authenticated
  WITH CHECK (account_id = auth.uid());
