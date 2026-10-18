-- Padroniza nome da tabela de config (ConfigSystem → config_system).

DO $$
BEGIN
  IF to_regclass('public."ConfigSystem"') IS NOT NULL
     AND to_regclass('public.config_system') IS NULL THEN
    ALTER TABLE public."ConfigSystem" RENAME TO config_system;
  END IF;
END $$;
