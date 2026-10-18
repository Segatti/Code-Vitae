-- Configurações globais do app (feature flags / manutenção).

CREATE TABLE IF NOT EXISTS public.config_system (
  key TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  value TEXT NOT NULL,
  CONSTRAINT config_system_type_check CHECK (
    type IN ('bool', 'string', 'number')
  )
);

ALTER TABLE public.config_system ENABLE ROW LEVEL SECURITY;

CREATE POLICY config_system_select_public
  ON public.config_system
  FOR SELECT
  TO anon, authenticated
  USING (true);

GRANT SELECT ON public.config_system TO anon;
GRANT SELECT ON public.config_system TO authenticated;

INSERT INTO public.config_system (key, type, value)
VALUES
  ('app_active', 'bool', 'true'),
  ('store_active', 'bool', 'true'),
  ('store_powerup_active', 'bool', 'true'),
  ('store_superstar_active', 'bool', 'true'),
  ('store_superchat_active', 'bool', 'true')
ON CONFLICT (key) DO NOTHING;
