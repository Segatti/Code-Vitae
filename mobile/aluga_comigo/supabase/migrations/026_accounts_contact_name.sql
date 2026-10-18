-- Nome do responsável (dados pessoais no cadastro imóvel), distinto do título do anúncio.

ALTER TABLE public.accounts
  ADD COLUMN IF NOT EXISTS contact_name TEXT NOT NULL DEFAULT '';

UPDATE public.accounts a
SET contact_name = COALESCE(NULLIF(TRIM(i.name), ''), a.contact_name)
FROM public.immobiles i
WHERE a.type_user = 'immobile'
  AND i.id = a.id
  AND TRIM(a.contact_name) = '';

UPDATE public.accounts a
SET contact_name = COALESCE(NULLIF(TRIM(p.name), ''), a.contact_name)
FROM public.persons p
WHERE a.type_user = 'person'
  AND p.id = a.id
  AND TRIM(a.contact_name) = '';
