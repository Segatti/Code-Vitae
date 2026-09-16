-- PowerUp semanal e mensal incluem Super Star e Super Chat.

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
    WHEN 'power_up_24h' THEN
      v_interval := INTERVAL '24 hours';
    WHEN 'power_up_7d' THEN
      v_interval := INTERVAL '7 days';
      UPDATE public.user_inventory
      SET
        super_star_balance = super_star_balance + 1,
        super_chat_balance = super_chat_balance + 1,
        updated_at = NOW()
      WHERE account_id = v_user_id;
    WHEN 'power_up_30d' THEN
      v_interval := INTERVAL '30 days';
      UPDATE public.user_inventory
      SET
        super_star_balance = super_star_balance + 4,
        super_chat_balance = super_chat_balance + 4,
        updated_at = NOW()
      WHERE account_id = v_user_id;
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
