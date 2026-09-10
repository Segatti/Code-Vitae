-- Aluga Comigo — schema relacional Supabase

CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  type_user TEXT NOT NULL CHECK (type_user IN ('person', 'immobile', 'none')),
  phone TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL DEFAULT '',
  state TEXT NOT NULL DEFAULT '',
  city TEXT NOT NULL DEFAULT '',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  last_match UUID REFERENCES public.profiles(id),
  photos TEXT[] NOT NULL DEFAULT '{}',
  short_description TEXT NOT NULL DEFAULT '',
  long_description TEXT NOT NULL DEFAULT '',
  score DOUBLE PRECISION NOT NULL DEFAULT 0,
  skills TEXT[] NOT NULL DEFAULT '{}',
  date_birth TEXT NOT NULL DEFAULT '',
  price_max_immobile DOUBLE PRECISION NOT NULL DEFAULT 0,
  desired_immobile TEXT NOT NULL DEFAULT 'none',
  life_style TEXT NOT NULL DEFAULT 'none',
  gender TEXT NOT NULL DEFAULT '',
  houseworks TEXT[] NOT NULL DEFAULT '{}',
  cep TEXT NOT NULL DEFAULT '',
  price DOUBLE PRECISION NOT NULL DEFAULT 0,
  type_immobile TEXT NOT NULL DEFAULT 'none',
  bathrooms INTEGER NOT NULL DEFAULT 0,
  bedrooms INTEGER NOT NULL DEFAULT 0,
  car_spaces INTEGER NOT NULL DEFAULT 0,
  is_market_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_school_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_hospital_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_park_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_gym_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_mall_near BOOLEAN NOT NULL DEFAULT FALSE,
  is_beach_near BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  to_profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  match_type TEXT NOT NULL,
  profile_snapshot JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (from_profile_id, to_profile_id)
);

CREATE INDEX IF NOT EXISTS idx_profiles_type_user ON public.profiles(type_user);
CREATE INDEX IF NOT EXISTS idx_profiles_is_active ON public.profiles(is_active);
CREATE INDEX IF NOT EXISTS idx_profiles_created_at ON public.profiles(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_matches_from_profile ON public.matches(from_profile_id);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY profiles_select_active
  ON public.profiles FOR SELECT
  TO authenticated
  USING (is_active = TRUE OR auth.uid() = id);

CREATE POLICY profiles_insert_own
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY profiles_update_own
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY matches_all_own
  ON public.matches FOR ALL
  TO authenticated
  USING (from_profile_id = auth.uid())
  WITH CHECK (from_profile_id = auth.uid());

INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', TRUE)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY avatars_public_read
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'avatars');

CREATE POLICY avatars_auth_upload
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY avatars_auth_update
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE OR REPLACE FUNCTION public.delete_own_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM auth.users WHERE id = auth.uid();
END;
$$;

GRANT EXECUTE ON FUNCTION public.delete_own_account() TO authenticated;
