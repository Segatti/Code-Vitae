-- Bloqueio entre contas (UGC) + metadados de denúncia em tickets.

CREATE TABLE IF NOT EXISTS public.account_blocks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blocker_account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  blocked_account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (blocker_account_id, blocked_account_id),
  CHECK (blocker_account_id <> blocked_account_id)
);

CREATE INDEX IF NOT EXISTS idx_account_blocks_blocker
  ON public.account_blocks(blocker_account_id);

CREATE INDEX IF NOT EXISTS idx_account_blocks_blocked
  ON public.account_blocks(blocked_account_id);

ALTER TABLE public.account_blocks ENABLE ROW LEVEL SECURITY;

CREATE POLICY account_blocks_select_own
  ON public.account_blocks FOR SELECT
  TO authenticated
  USING (blocker_account_id = auth.uid());

CREATE POLICY account_blocks_insert_own
  ON public.account_blocks FOR INSERT
  TO authenticated
  WITH CHECK (blocker_account_id = auth.uid());

CREATE POLICY account_blocks_delete_own
  ON public.account_blocks FOR DELETE
  TO authenticated
  USING (blocker_account_id = auth.uid());

ALTER TABLE public.support_tickets
  ADD COLUMN IF NOT EXISTS reported_account_id UUID REFERENCES public.accounts(id) ON DELETE SET NULL;

ALTER TABLE public.support_tickets
  ADD COLUMN IF NOT EXISTS report_context TEXT CHECK (
    report_context IS NULL
    OR report_context IN ('profile', 'chat', 'listing')
  );

CREATE INDEX IF NOT EXISTS idx_support_tickets_reported_account
  ON public.support_tickets(reported_account_id)
  WHERE reported_account_id IS NOT NULL;
