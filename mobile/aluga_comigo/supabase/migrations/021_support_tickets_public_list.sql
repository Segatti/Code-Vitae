-- Feed de tickets: usuários autenticados veem todos os tickets e podem
-- reagir/comentar em tickets abertos de outros.

DROP POLICY IF EXISTS support_tickets_select_own ON public.support_tickets;
DROP POLICY IF EXISTS support_tickets_select_authenticated ON public.support_tickets;

CREATE POLICY support_tickets_select_authenticated
  ON public.support_tickets FOR SELECT
  TO authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_support_tickets_created
  ON public.support_tickets(created_at DESC);

DROP POLICY IF EXISTS support_ticket_reactions_select_own
  ON public.support_ticket_reactions;
DROP POLICY IF EXISTS support_ticket_reactions_select_authenticated
  ON public.support_ticket_reactions;

CREATE POLICY support_ticket_reactions_select_authenticated
  ON public.support_ticket_reactions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id
    )
  );

DROP POLICY IF EXISTS support_ticket_reactions_insert_own
  ON public.support_ticket_reactions;
DROP POLICY IF EXISTS support_ticket_reactions_insert_authenticated
  ON public.support_ticket_reactions;

CREATE POLICY support_ticket_reactions_insert_authenticated
  ON public.support_ticket_reactions FOR INSERT
  TO authenticated
  WITH CHECK (
    account_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id
    )
  );

DROP POLICY IF EXISTS support_ticket_comments_select_own
  ON public.support_ticket_comments;
DROP POLICY IF EXISTS support_ticket_comments_select_authenticated
  ON public.support_ticket_comments;

CREATE POLICY support_ticket_comments_select_authenticated
  ON public.support_ticket_comments FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id
    )
  );

DROP POLICY IF EXISTS support_ticket_comments_insert_open
  ON public.support_ticket_comments;

CREATE POLICY support_ticket_comments_insert_open
  ON public.support_ticket_comments FOR INSERT
  TO authenticated
  WITH CHECK (
    account_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.support_tickets t
      WHERE t.id = ticket_id
        AND t.status = 'open'
    )
  );
