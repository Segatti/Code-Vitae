-- Loja: inventário, compras, missões e RPCs de fulfillment

CREATE TABLE IF NOT EXISTS public.user_inventory (
  account_id UUID PRIMARY KEY REFERENCES public.accounts(id) ON DELETE CASCADE,
  super_star_balance INT NOT NULL DEFAULT 0 CHECK (super_star_balance >= 0),
  super_chat_balance INT NOT NULL DEFAULT 0 CHECK (super_chat_balance >= 0),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.user_purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('google', 'apple', 'dev')),
  store_transaction_id TEXT NOT NULL UNIQUE,
  purchased_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_purchases_account
  ON public.user_purchases(account_id, purchased_at DESC);

CREATE TABLE IF NOT EXISTS public.quest_definitions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  target_count INT NOT NULL CHECK (target_count > 0),
  reward_amount INT NOT NULL CHECK (reward_amount > 0),
  reward_type TEXT NOT NULL CHECK (reward_type IN ('superStar', 'superChat', 'like')),
  action_type TEXT NOT NULL CHECK (action_type IN ('like', 'favorite'))
);

CREATE TABLE IF NOT EXISTS public.user_quest_progress (
  account_id UUID NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  quest_id TEXT NOT NULL REFERENCES public.quest_definitions(id) ON DELETE CASCADE,
  progress_count INT NOT NULL DEFAULT 0 CHECK (progress_count >= 0),
  completed_at TIMESTAMPTZ,
  claimed_at TIMESTAMPTZ,
  PRIMARY KEY (account_id, quest_id)
);

ALTER TABLE public.user_inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quest_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_quest_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_inventory_select_own ON public.user_inventory
  FOR SELECT USING (account_id = auth.uid());

CREATE POLICY user_purchases_select_own ON public.user_purchases
  FOR SELECT USING (account_id = auth.uid());

CREATE POLICY quest_definitions_select_all ON public.quest_definitions
  FOR SELECT USING (TRUE);

CREATE POLICY user_quest_progress_select_own ON public.user_quest_progress
  FOR SELECT USING (account_id = auth.uid());

INSERT INTO public.quest_definitions (id, title, target_count, reward_amount, reward_type, action_type)
VALUES
  ('like_10', 'Curta 10 pessoas ou imóveis', 10, 2, 'superStar', 'like'),
  ('super_star_1', 'Dê 1 Super Star', 1, 1, 'superChat', 'favorite')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- RPC: inventário
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_user_inventory()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_row public.user_inventory%ROWTYPE;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  INSERT INTO public.user_inventory (account_id)
  VALUES (v_user_id)
  ON CONFLICT (account_id) DO NOTHING;

  SELECT * INTO v_row FROM public.user_inventory WHERE account_id = v_user_id;

  RETURN jsonb_build_object(
    'superStarBalance', v_row.super_star_balance,
    'superChatBalance', v_row.super_chat_balance
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.consume_super_star()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
BEGIN
  IF v_user_id IS NULL THEN
    RETURN FALSE;
  END IF;

  INSERT INTO public.user_inventory (account_id)
  VALUES (v_user_id)
  ON CONFLICT (account_id) DO NOTHING;

  UPDATE public.user_inventory
  SET super_star_balance = super_star_balance - 1,
      updated_at = NOW()
  WHERE account_id = v_user_id
    AND super_star_balance > 0;

  RETURN FOUND;
END;
$$;

CREATE OR REPLACE FUNCTION public.consume_super_chat()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
BEGIN
  IF v_user_id IS NULL THEN
    RETURN FALSE;
  END IF;

  INSERT INTO public.user_inventory (account_id)
  VALUES (v_user_id)
  ON CONFLICT (account_id) DO NOTHING;

  UPDATE public.user_inventory
  SET super_chat_balance = super_chat_balance - 1,
      updated_at = NOW()
  WHERE account_id = v_user_id
    AND super_chat_balance > 0;

  RETURN FOUND;
END;
$$;

-- ---------------------------------------------------------------------------
-- RPC: fulfillment de compra (Google / Apple)
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.fulfill_purchase(
  p_product_id TEXT,
  p_transaction_id TEXT,
  p_platform TEXT DEFAULT 'google'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_type_user TEXT;
  v_interval INTERVAL;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.user_purchases
    WHERE store_transaction_id = p_transaction_id
  ) THEN
    RETURN jsonb_build_object('ok', TRUE, 'duplicate', TRUE);
  END IF;

  INSERT INTO public.user_purchases (account_id, product_id, platform, store_transaction_id)
  VALUES (v_user_id, p_product_id, p_platform, p_transaction_id);

  INSERT INTO public.user_inventory (account_id)
  VALUES (v_user_id)
  ON CONFLICT (account_id) DO NOTHING;

  CASE p_product_id
    WHEN 'super_star_1' THEN
      UPDATE public.user_inventory SET super_star_balance = super_star_balance + 1, updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'super_star_2' THEN
      UPDATE public.user_inventory SET super_star_balance = super_star_balance + 3, updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'super_star_3' THEN
      UPDATE public.user_inventory SET super_star_balance = super_star_balance + 5, updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'super_chat_1' THEN
      UPDATE public.user_inventory SET super_chat_balance = super_chat_balance + 1, updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'super_chat_2' THEN
      UPDATE public.user_inventory SET super_chat_balance = super_chat_balance + 3, updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'super_chat_3' THEN
      UPDATE public.user_inventory SET super_chat_balance = super_chat_balance + 5, updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'power_up_24h' THEN v_interval := INTERVAL '24 hours';
    WHEN 'power_up_7d' THEN v_interval := INTERVAL '7 days';
    WHEN 'power_up_30d' THEN v_interval := INTERVAL '30 days';
    ELSE
      RAISE EXCEPTION 'unknown product: %', p_product_id;
  END CASE;

  IF v_interval IS NOT NULL THEN
    SELECT type_user INTO v_type_user FROM public.accounts WHERE id = v_user_id;

    IF v_type_user = 'person' THEN
      UPDATE public.persons
      SET power_up_until = GREATEST(COALESCE(power_up_until, NOW()), NOW()) + v_interval
      WHERE id = v_user_id;
    ELSIF v_type_user = 'immobile' THEN
      UPDATE public.immobiles
      SET power_up_until = GREATEST(COALESCE(power_up_until, NOW()), NOW()) + v_interval
      WHERE id = v_user_id;
    END IF;
  END IF;

  RETURN jsonb_build_object('ok', TRUE);
END;
$$;

-- ---------------------------------------------------------------------------
-- RPC: conta / missões
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.set_account_active(p_active BOOLEAN)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  UPDATE public.accounts
  SET is_active = p_active
  WHERE id = auth.uid();
END;
$$;

CREATE OR REPLACE FUNCTION public.increment_quest_progress(p_action_type TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_quest RECORD;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN;
  END IF;

  FOR v_quest IN
    SELECT * FROM public.quest_definitions WHERE action_type = p_action_type
  LOOP
    INSERT INTO public.user_quest_progress (account_id, quest_id, progress_count)
    VALUES (v_user_id, v_quest.id, 1)
    ON CONFLICT (account_id, quest_id)
    DO UPDATE SET progress_count = public.user_quest_progress.progress_count + 1;

    UPDATE public.user_quest_progress uqp
    SET completed_at = COALESCE(uqp.completed_at, NOW())
    FROM public.quest_definitions qd
    WHERE uqp.account_id = v_user_id
      AND uqp.quest_id = v_quest.id
      AND uqp.quest_id = qd.id
      AND uqp.progress_count >= qd.target_count
      AND uqp.completed_at IS NULL;
  END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_user_quests()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  RETURN COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'id', qd.id,
        'title', qd.title,
        'targetCount', qd.target_count,
        'progressCount', COALESCE(uqp.progress_count, 0),
        'rewardAmount', qd.reward_amount,
        'rewardType', qd.reward_type,
        'isCompleted', COALESCE(uqp.completed_at IS NOT NULL, FALSE),
        'isClaimed', COALESCE(uqp.claimed_at IS NOT NULL, FALSE)
      )
      ORDER BY qd.id
    )
    FROM public.quest_definitions qd
    LEFT JOIN public.user_quest_progress uqp
      ON uqp.quest_id = qd.id AND uqp.account_id = v_user_id
  ), '[]'::jsonb);
END;
$$;

CREATE OR REPLACE FUNCTION public.claim_quest_reward(p_quest_id TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_quest public.quest_definitions%ROWTYPE;
  v_progress public.user_quest_progress%ROWTYPE;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  SELECT * INTO v_quest FROM public.quest_definitions WHERE id = p_quest_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'quest not found';
  END IF;

  SELECT * INTO v_progress
  FROM public.user_quest_progress
  WHERE account_id = v_user_id AND quest_id = p_quest_id;

  IF v_progress.completed_at IS NULL OR v_progress.claimed_at IS NOT NULL THEN
    RAISE EXCEPTION 'reward not available';
  END IF;

  INSERT INTO public.user_inventory (account_id)
  VALUES (v_user_id)
  ON CONFLICT (account_id) DO NOTHING;

  IF v_quest.reward_type = 'superStar' THEN
    UPDATE public.user_inventory
    SET super_star_balance = super_star_balance + v_quest.reward_amount,
        updated_at = NOW()
    WHERE account_id = v_user_id;
  ELSIF v_quest.reward_type = 'superChat' THEN
    UPDATE public.user_inventory
    SET super_chat_balance = super_chat_balance + v_quest.reward_amount,
        updated_at = NOW()
    WHERE account_id = v_user_id;
  END IF;

  UPDATE public.user_quest_progress
  SET claimed_at = NOW()
  WHERE account_id = v_user_id AND quest_id = p_quest_id;

  RETURN jsonb_build_object('ok', TRUE);
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_user_inventory() TO authenticated;
GRANT EXECUTE ON FUNCTION public.consume_super_star() TO authenticated;
GRANT EXECUTE ON FUNCTION public.consume_super_chat() TO authenticated;
GRANT EXECUTE ON FUNCTION public.fulfill_purchase(TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.set_account_active(BOOLEAN) TO authenticated;
GRANT EXECUTE ON FUNCTION public.increment_quest_progress(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_quests() TO authenticated;
GRANT EXECUTE ON FUNCTION public.claim_quest_reward(TEXT) TO authenticated;
