-- Dados de exemplo para desenvolvimento local (Aluga Comigo)
-- Senha de todos os usuários demo: demo123
--
-- Pessoas:  ana@demo.local, bruno@demo.local, carla@demo.local
-- Imóveis:  apt.centro@demo.local, casa.jardins@demo.local, kit.vila@demo.local
--
-- Match mútuo (gera chat): Ana ↔ Apto Centro
-- Curtidas recebidas (ex.): Bruno deu Super Star no Apto; Casa Jardins curtiu Ana
-- PowerUp ativo (ex.): Bruno Costa aparece em destaque na busca por 7 dias
-- Histórico rejeitados (ex.): Ana rejeitou Casa Jardins; Apto Centro rejeitou Carla

-- ---------------------------------------------------------------------------
-- Auth (login local)
-- ---------------------------------------------------------------------------

INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  recovery_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES
  (
    '00000000-0000-0000-0000-000000000000',
    '11111111-1111-1111-1111-111111111111',
    'authenticated',
    'authenticated',
    'ana@demo.local',
    crypt('demo123', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Ana Silva"}',
    NOW(), NOW(),
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '22222222-2222-2222-2222-222222222222',
    'authenticated',
    'authenticated',
    'bruno@demo.local',
    crypt('demo123', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Bruno Costa"}',
    NOW(), NOW(),
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '33333333-3333-3333-3333-333333333333',
    'authenticated',
    'authenticated',
    'carla@demo.local',
    crypt('demo123', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Carla Mendes"}',
    NOW(), NOW(),
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'authenticated',
    'authenticated',
    'apt.centro@demo.local',
    crypt('demo123', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Apto Centro"}',
    NOW(), NOW(),
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'authenticated',
    'authenticated',
    'casa.jardins@demo.local',
    crypt('demo123', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Casa Jardins"}',
    NOW(), NOW(),
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
    'authenticated',
    'authenticated',
    'kit.vila@demo.local',
    crypt('demo123', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Kit Vila Mariana"}',
    NOW(), NOW(),
    '', '', '', ''
  );

INSERT INTO auth.identities (
  id,
  user_id,
  provider_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
) VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    '{"sub":"11111111-1111-1111-1111-111111111111","email":"ana@demo.local"}'::jsonb,
    'email',
    NOW(), NOW(), NOW()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    '22222222-2222-2222-2222-222222222222',
    '22222222-2222-2222-2222-222222222222',
    '{"sub":"22222222-2222-2222-2222-222222222222","email":"bruno@demo.local"}'::jsonb,
    'email',
    NOW(), NOW(), NOW()
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    '33333333-3333-3333-3333-333333333333',
    '33333333-3333-3333-3333-333333333333',
    '{"sub":"33333333-3333-3333-3333-333333333333","email":"carla@demo.local"}'::jsonb,
    'email',
    NOW(), NOW(), NOW()
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1","email":"apt.centro@demo.local"}'::jsonb,
    'email',
    NOW(), NOW(), NOW()
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2","email":"casa.jardins@demo.local"}'::jsonb,
    'email',
    NOW(), NOW(), NOW()
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
    '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3","email":"kit.vila@demo.local"}'::jsonb,
    'email',
    NOW(), NOW(), NOW()
  );

-- ---------------------------------------------------------------------------
-- Contas
-- ---------------------------------------------------------------------------

INSERT INTO public.accounts (id, email, type_user, phone, is_active) VALUES
  ('11111111-1111-1111-1111-111111111111', 'ana@demo.local', 'person', '11999990001', TRUE),
  ('22222222-2222-2222-2222-222222222222', 'bruno@demo.local', 'person', '11999990002', TRUE),
  ('33333333-3333-3333-3333-333333333333', 'carla@demo.local', 'person', '11999990003', TRUE),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'apt.centro@demo.local', 'immobile', '11988880001', TRUE),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'casa.jardins@demo.local', 'immobile', '11988880002', TRUE),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'kit.vila@demo.local', 'immobile', '11988880003', TRUE);

-- ---------------------------------------------------------------------------
-- Pessoas (São Paulo - SP)
-- ---------------------------------------------------------------------------

INSERT INTO public.persons (
  id, name, state, city, photos,
  short_description, long_description, score,
  skills, date_birth, price_max_immobile,
  desired_immobile, life_style, gender, houseworks,
  power_up_until
) VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    'Ana Silva',
    'SP',
    'São Paulo',
    ARRAY['https://picsum.photos/seed/ana-demo/600/800'],
    'Estudante organizada, busca apê tranquilo.',
    'Trabalho remoto, não fumo e gosto de ambientes silenciosos.',
    4.5,
    ARRAY['cucaMaster', 'laundryOperator'],
    '12/05/1998',
    2500,
    'apartment',
    'stayingAtHome',
    'Feminino',
    ARRAY['cooking', 'cleaning'],
    NULL
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'Bruno Costa',
    'SP',
    'São Paulo',
    ARRAY['https://picsum.photos/seed/bruno-demo/600/800'],
    'Profissional de TI, prático no dia a dia.',
    'Procuro imóvel bem localizado com boa internet.',
    4.2,
    ARRAY['ninjaInSweeping'],
    '1995-11-03',
    3200,
    'apartment',
    'working',
    'Masculino',
    ARRAY['cleaning'],
    NOW() + INTERVAL '7 days'
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'Carla Mendes',
    'SP',
    'São Paulo',
    ARRAY['https://picsum.photos/seed/carla-demo/600/800'],
    'Designer, curte espaços criativos.',
    'Tenho gato e preciso de apartamento pet friendly.',
    4.8,
    ARRAY['humanDishwasher', 'cucaMaster'],
    '1999-08-21',
    2800,
    'house',
    'partying',
    'Feminino',
    ARRAY['cooking'],
    NULL
  );

-- ---------------------------------------------------------------------------
-- Imóveis (São Paulo - SP)
-- ---------------------------------------------------------------------------

INSERT INTO public.immobiles (
  id, name, state, city, cep, photos,
  short_description, long_description, score,
  price, type_immobile, bathrooms, bedrooms, car_spaces,
  is_market_near, is_school_near, is_hospital_near,
  is_park_near, is_gym_near, is_mall_near, is_beach_near
) VALUES
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
    'Apto 2 dorm Centro',
    'SP',
    'São Paulo',
    '01001000',
    ARRAY['https://picsum.photos/seed/apt-centro/600/800'],
    'Apartamento compacto no centro.',
    '2 quartos, 1 vaga, metrô a 5 min. Ideal para quem trabalha na região.',
    4.6,
    2200,
    'apartment',
    1, 2, 1,
    TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
    'Casa Jardins',
    'SP',
    'São Paulo',
    '01415001',
    ARRAY['https://picsum.photos/seed/casa-jardins/600/800'],
    'Casa ampla nos Jardins.',
    '3 quartos, quintal e churrasqueira. Bairro residencial e seguro.',
    4.9,
    4500,
    'house',
    3, 3, 2,
    TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE
  ),
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
    'Kitnet Vila Mariana',
    'SP',
    'São Paulo',
    '04101001',
    ARRAY['https://picsum.photos/seed/kit-vila/600/800'],
    'Kitnet mobiliada para estudantes.',
    'Próximo à UNIFESP e ao metrô Ana Rosa.',
    4.1,
    1500,
    'apartment',
    1, 1, 0,
    TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE
  );

-- ---------------------------------------------------------------------------
-- Matches
-- ---------------------------------------------------------------------------

-- Match mútuo: Ana ↔ Apto Centro (dispara trigger de chat)
INSERT INTO public.person_matches (person_id, immobile_id, match_type) VALUES
  ('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'like');

INSERT INTO public.immobile_matches (immobile_id, person_id, match_type) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '11111111-1111-1111-1111-111111111111', 'like');

-- Super Star recebido pelo Apto Centro (de Bruno)
INSERT INTO public.person_matches (person_id, immobile_id, match_type) VALUES
  ('22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'favorite');

-- Curtida recebida pela Ana (da Casa Jardins)
INSERT INTO public.immobile_matches (immobile_id, person_id, match_type) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '11111111-1111-1111-1111-111111111111', 'like');

-- Outros matches parciais (sem chat)
INSERT INTO public.person_matches (person_id, immobile_id, match_type) VALUES
  ('33333333-3333-3333-3333-333333333333', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'like'),
  ('22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'like');

-- Rejeições para histórico (Ana rejeitou Casa Jardins)
INSERT INTO public.person_matches (person_id, immobile_id, match_type) VALUES
  ('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'unlike');

-- Rejeições para histórico (Apto Centro rejeitou Carla)
INSERT INTO public.immobile_matches (immobile_id, person_id, match_type) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '33333333-3333-3333-3333-333333333333', 'unlike');

-- Inventário demo (Super Stars para testar swipe e curtidas)
INSERT INTO public.user_inventory (account_id, super_star_balance, super_chat_balance) VALUES
  ('11111111-1111-1111-1111-111111111111', 3, 1),
  ('22222222-2222-2222-2222-222222222222', 2, 0),
  ('33333333-3333-3333-3333-333333333333', 1, 1),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 2, 2),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 1, 0),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 0, 1)
ON CONFLICT (account_id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- Mensagens do chat de exemplo (Ana ↔ Apto Centro)
-- ---------------------------------------------------------------------------

INSERT INTO public.messages (chat_id, sender_id, content, message_type, created_at)
SELECT
  c.id,
  '11111111-1111-1111-1111-111111111111',
  'Olá! Tenho interesse no apartamento. Ainda está disponível?',
  'text',
  NOW() - INTERVAL '2 hours'
FROM public.chats c
WHERE c.person_id = '11111111-1111-1111-1111-111111111111'
  AND c.immobile_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1';

INSERT INTO public.messages (chat_id, sender_id, content, message_type, created_at)
SELECT
  c.id,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
  'Oi Ana! Sim, está disponível. Quer agendar uma visita?',
  'text',
  NOW() - INTERVAL '1 hour'
FROM public.chats c
WHERE c.person_id = '11111111-1111-1111-1111-111111111111'
  AND c.immobile_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1';

INSERT INTO public.messages (chat_id, sender_id, content, message_type, created_at)
SELECT
  c.id,
  '11111111-1111-1111-1111-111111111111',
  'Quero sim! Pode ser amanhã à tarde?',
  'text',
  NOW() - INTERVAL '30 minutes'
FROM public.chats c
WHERE c.person_id = '11111111-1111-1111-1111-111111111111'
  AND c.immobile_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1';
