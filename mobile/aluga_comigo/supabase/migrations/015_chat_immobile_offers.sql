-- Ofertas de imóveis na conversa (não entram em messages).

CREATE TABLE IF NOT EXISTS public.chat_immobile_offers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chat_id UUID NOT NULL REFERENCES public.chats(id) ON DELETE CASCADE,
  immobile_id UUID NOT NULL REFERENCES public.immobiles(id) ON DELETE CASCADE,
  offered_by_account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (chat_id, immobile_id)
);

CREATE INDEX IF NOT EXISTS idx_chat_immobile_offers_chat_created
  ON public.chat_immobile_offers(chat_id, created_at DESC);

ALTER TABLE public.chat_immobile_offers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS chat_immobile_offers_select ON public.chat_immobile_offers;
CREATE POLICY chat_immobile_offers_select
  ON public.chat_immobile_offers FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = chat_immobile_offers.chat_id
        AND (
          c.person_id = auth.uid()
          OR c.immobile_id = auth.uid()
          OR public.immobile_owned_by_auth(c.immobile_id)
        )
    )
  );

DROP POLICY IF EXISTS chat_immobile_offers_insert ON public.chat_immobile_offers;
CREATE POLICY chat_immobile_offers_insert
  ON public.chat_immobile_offers FOR INSERT
  TO authenticated
  WITH CHECK (
    offered_by_account_id = auth.uid()
    AND public.immobile_owned_by_auth(immobile_id)
    AND EXISTS (
      SELECT 1 FROM public.chats c
      WHERE c.id = chat_id
        AND (
          c.person_id = auth.uid()
          OR c.immobile_id = auth.uid()
          OR public.immobile_owned_by_auth(c.immobile_id)
        )
    )
  );
