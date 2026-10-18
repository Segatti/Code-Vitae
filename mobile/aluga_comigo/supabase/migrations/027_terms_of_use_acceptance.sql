-- Termos de uso: versão vigente (config) e aceite por conta.

ALTER TABLE public.accounts
  ADD COLUMN IF NOT EXISTS terms_of_use_version_accepted TEXT,
  ADD COLUMN IF NOT EXISTS terms_of_use_accepted_at TIMESTAMPTZ;

INSERT INTO public.config_system (key, type, value)
VALUES ('terms_of_use_current_version', 'string', '1.0')
ON CONFLICT (key) DO UPDATE
SET type = EXCLUDED.type,
    value = EXCLUDED.value;

-- Registra aceite da versão vigente (somente o próprio usuário autenticado).
CREATE OR REPLACE FUNCTION public.accept_terms_of_use(p_version TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  IF p_version IS NULL OR trim(p_version) = '' THEN
    RAISE EXCEPTION 'invalid_version';
  END IF;

  UPDATE public.accounts
  SET
    terms_of_use_version_accepted = trim(p_version),
    terms_of_use_accepted_at = NOW()
  WHERE id = auth.uid();
END;
$$;

REVOKE ALL ON FUNCTION public.accept_terms_of_use(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.accept_terms_of_use(TEXT) TO authenticated;
