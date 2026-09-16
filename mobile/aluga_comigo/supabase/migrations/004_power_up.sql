-- PowerUp: destaque de perfil na mesma cidade

ALTER TABLE public.persons
  ADD COLUMN IF NOT EXISTS power_up_until TIMESTAMPTZ;

ALTER TABLE public.immobiles
  ADD COLUMN IF NOT EXISTS power_up_until TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_persons_power_up_until
  ON public.persons(power_up_until DESC NULLS LAST);

CREATE INDEX IF NOT EXISTS idx_immobiles_power_up_until
  ON public.immobiles(power_up_until DESC NULLS LAST);
