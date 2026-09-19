# Aluga Comigo — Backend Dart

API HTTP intermediária entre o app Flutter e o PostgreSQL (Supabase local/remoto). Concentra operações críticas (loja, inventário, missões, conta ativa) reutilizando as **RPCs SQL** existentes com `auth.uid()`.

## Pré-requisitos

- Dart SDK ^3.10 (mesmo do app)
- Supabase local rodando (`../scripts/initDev.sh` ou `supabase start`)

## Rodar

```bash
cd mobile/aluga_comigo
chmod +x scripts/runBackend.sh
./scripts/runBackend.sh
```

Health check: `curl http://127.0.0.1:8080/health`

## Configuração

Variáveis (ou arquivo `backend/.env`):

| Variável | Padrão local |
|----------|----------------|
| `PORT` | `8080` |
| `DATABASE_URL` | `postgresql://postgres:postgres@127.0.0.1:54322/postgres` |
| `SUPABASE_JWT_SECRET` | de `supabase status -o env` → `JWT_SECRET` |

O app envia `Authorization: Bearer <access_token>` (JWT do Supabase Auth).

## Rotas (v1)

| Método | Path | RPC / efeito |
|--------|------|----------------|
| GET | `/health` | — |
| GET | `/v1/inventory` | `get_user_inventory` |
| POST | `/v1/inventory/consume-super-star` | `consume_super_star` |
| POST | `/v1/inventory/consume-super-chat` | `consume_super_chat` |
| POST | `/v1/purchases/fulfill` | `fulfill_purchase` |
| PATCH | `/v1/account/active` | `set_account_active` |
| POST | `/v1/quests/progress` | `increment_quest_progress` |
| GET | `/v1/quests` | `get_user_quests` |
| POST | `/v1/quests/:questId/claim` | `claim_quest_reward` |

## App Flutter

Define `BACKEND_API_URL` via `--dart-define-from-file` (gerado pelo `initDev.sh`).
