-- Verifica disponibilidade de e-mail no cadastro (anon/authenticated).
-- Aplique no projeto Supabase (SQL Editor ou supabase db push).

CREATE OR REPLACE FUNCTION public.is_signup_email_available(p_email TEXT)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, auth
STABLE
AS $$
  SELECT NOT EXISTS (
    SELECT 1
    FROM auth.users u
    WHERE lower(trim(u.email)) = lower(trim(p_email))
  );
$$;

REVOKE ALL ON FUNCTION public.is_signup_email_available(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_signup_email_available(TEXT) TO anon, authenticated;

NOTIFY pgrst, 'reload schema';
