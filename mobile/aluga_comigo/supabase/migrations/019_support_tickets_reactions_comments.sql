-- Status, reações (like/dislike) e comentários nos tickets de suporte.

ALTER TABLE public.support_tickets
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'open'
  CHECK (status IN ('open', 'closed'));

CREATE TABLE IF NOT EXISTS public.support_ticket_reactions (
  ticket_id UUID NOT NULL REFERENCES public.support_tickets(id) ON DELETE CASCADE,
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  reaction TEXT NOT NULL CHECK (reaction IN ('like', 'dislike')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (ticket_id, account_id)
);

CREATE TABLE IF NOT EXISTS public.support_ticket_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES public.support_tickets(id) ON DELETE CASCADE,
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  body TEXT NOT NULL CHECK (char_length(trim(body)) >= 1),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_support_ticket_comments_ticket_created
  ON public.support_ticket_comments(ticket_id, created_at ASC);

ALTER TABLE public.support_ticket_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_ticket_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY support_ticket_reactions_select_own
  ON public.support_ticket_reactions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id AND t.account_id = auth.uid()
    )
  );

CREATE POLICY support_ticket_reactions_insert_own
  ON public.support_ticket_reactions FOR INSERT
  TO authenticated
  WITH CHECK (
    account_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id AND t.account_id = auth.uid()
    )
  );

CREATE POLICY support_ticket_reactions_update_own
  ON public.support_ticket_reactions FOR UPDATE
  TO authenticated
  USING (account_id = auth.uid())
  WITH CHECK (account_id = auth.uid());

CREATE POLICY support_ticket_reactions_delete_own
  ON public.support_ticket_reactions FOR DELETE
  TO authenticated
  USING (account_id = auth.uid());

CREATE POLICY support_ticket_comments_select_own
  ON public.support_ticket_comments FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id AND t.account_id = auth.uid()
    )
  );

CREATE POLICY support_ticket_comments_insert_open
  ON public.support_ticket_comments FOR INSERT
  TO authenticated
  WITH CHECK (
    account_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id
        AND t.account_id = auth.uid()
        AND t.status = 'open'
    )
  );
