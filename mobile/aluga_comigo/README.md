# Aluga Comigo

App mobile (Flutter) para conectar **pessoas** que buscam imóvel e **anunciantes** (contas imóvel), com fluxo estilo swipe/match, chat, curtidas e loja de power-ups (Super Chat, Super Star).

Este repositório fica em `mobile/aluga_comigo` dentro do monorepo **Code-Vitae**.

---

## Checklist do projeto

Visão do que **já existe neste repositório** e do que **ainda está previsto**.

### Produto e plataforma

- [x] App **Flutter** mobile (Android / iOS)
- [x] Contas **pessoa** e **imóvel** (cadastro, login, perfil)
- [x] Feed swipe (curtir / não curtir / favorito / Super Chat no imóvel)
- [x] Match, curtidas recebidas, histórico
- [x] Chat (pessoa↔pessoa e pessoa↔imóvel), Super Chat na conversa, ofertas de imóvel
- [x] Vários anúncios por conta imóvel (`my_immobiles`)
- [x] Loja in-app (Super Star, Super Chat, PowerUp), missões (quests), notificações
- [x] **Backend Dart dedicado** (`backend/`) — loja, inventário, missões e conta ativa via API; demais fluxos ainda no Supabase client

### Arquitetura (app)

- [x] **Clean Architecture** por módulo: `domain` → `data` → `ui` / `presenter`
- [x] Injeção de dependência e rotas com **flutter_modular** v7
- [x] Estado de tela com **ChangeNotifier** + interfaces `I*Controller`
- [x] Erros com **dartz** / **result_dart** nos fluxos principais
- [x] Regras e mapa detalhado: [`AGENTS.md`](./AGENTS.md) e `.cursor/rules/`

### Banco de dados e backend atual (Supabase)

- [x] **PostgreSQL** com migrations versionadas em `supabase/migrations/` (schema, RLS, functions RPC)
- [x] **Supabase Auth** (e-mail/senha)
- [x] **Storage** (fotos de perfil / anúncios)
- [x] **Realtime** (chat e inbox)
- [x] Seed local de demonstração (`supabase/seed.sql`)
- [x] Ambiente local via Docker + Supabase CLI (`scripts/initDev.sh`)
- [x] Backend **Dart** (`backend/`, Postgres direto + JWT Supabase) para regras críticas de loja/missões
- [ ] Filas, integrações externas e migração total do client — fase posterior

### Módulos principais no código (`lib/app/modules/`)

| Módulo | Função |
|--------|--------|
| `auth` | Login, cadastro pessoa/imóvel |
| `intro` | Onboarding |
| `start` | Shell do app (abas: pessoas, imóveis, curtidas, chats, config) |
| `customer` / `house` | Swipe de perfis / imóveis |
| `like` | Curtidas recebidas, Super Star, agrupamento por imóvel |
| `chats` | Lista e conversas, contatos |
| `config` | Perfil e edição |
| `my_immobiles` | Listagem e criação de anúncios |
| `store` | Compras e inventário (power-ups) |
| `quest` | Missões |
| `notifications` | Notificações in-app |

### DevOps / qualidade

- [x] Scripts de dev local (`initDev.sh`, `genDeviceDefines.sh`)
- [x] Defines de ambiente (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) — sem secrets no Git
- [x] `dart analyze`, `dart format`, testes em `test/`
- [ ] CI/CD e deploy de backend dedicado — quando o backend existir

---

## Stack

| Camada | Tecnologia |
|--------|------------|
| UI | Flutter 3.x, Dart 3.10+ |
| Rotas / DI | [flutter_modular](https://pub.dev/packages/flutter_modular) v7 |
| Estado de tela | `ChangeNotifier` + interfaces `I*Controller` |
| Backend | [Supabase](https://supabase.com/) + API **Dart** (`backend/`, porta 8080) |
| Arquitetura | Clean Architecture (`domain` → `data` → `ui` / `presenter`) |

Documentação para contribuidores e agentes: [`AGENTS.md`](./AGENTS.md).

---

## Pré-requisitos

Instale e configure **antes** de rodar o projeto:

1. **Flutter SDK** compatível com Dart `^3.10` (canal stable recomendado)  
   - Verifique: `flutter doctor`
2. **Android Studio** e/ou **Xcode** (iOS no macOS), conforme a plataforma alvo
3. **Docker** (obrigatório para Supabase local)  
   - Linux: daemon ativo (`docker info`)
4. **Supabase CLI** — uma das opções:
   - `npm install -g supabase`, ou
   - usar `npx supabase@latest` (como nos comandos abaixo)
5. **Node.js + npx** (se não instalar o CLI globalmente)
6. **Git**

Opcional: **jq** (melhora a leitura de `supabase status -o json` no script de dev).

---

## Rodar do zero (recomendado — Supabase local)

Todo o fluxo abaixo assume que você está na pasta do app:

```bash
cd mobile/aluga_comigo
```

### 1. Dependências Flutter

```bash
flutter pub get
```

### 2. Ambiente Supabase + credenciais do app

O script **`scripts/initDev.sh`** sobe o Supabase local, aplica migrations + seed, gera os arquivos de `--dart-define` e roda `flutter pub get`:

```bash
chmod +x scripts/initDev.sh
./scripts/initDev.sh
```

O que ele faz, em resumo:

- `supabase start`
- `supabase db reset` (migrations em `supabase/migrations/` + `supabase/seed.sql`)
- Gera (gitignored):
  - `dart_defines.json` — simulador / desktop (`127.0.0.1`)
  - `dart_defines.android.json` — emulador Android (`10.0.2.2`)
  - `dart_defines.device.json` — celular físico na mesma Wi-Fi (IP da LAN)
  - Em todos: `DESIGN_SCREEN_WIDTH` / `DESIGN_SCREEN_HEIGHT` = **390×844** (artboard Figma / iPhone 14) para `.w()` / `.h()` / `.sp()`

**URLs úteis após o start:**

| Serviço | URL local |
|---------|-----------|
| API Supabase | http://127.0.0.1:54321 |
| Studio | http://127.0.0.1:54323 |
| E-mail (Inbucket) | http://127.0.0.1:54324 |

### 3. Executar o app

Simulador, desktop ou iOS Simulator:

```bash
flutter run --dart-define-from-file=dart_defines.json
```

Emulador Android:

```bash
flutter run --dart-define-from-file=dart_defines.android.json
```

Celular físico (mesma rede Wi-Fi; gere/atualize defines se mudou de rede):

```bash
./scripts/genDeviceDefines.sh
flutter run --dart-define-from-file=dart_defines.device.json
```

As variáveis injetadas são:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Definidas em [`lib/app/shared/domain/consts/env_config.dart`](./lib/app/shared/domain/consts/env_config.dart). **Não commite** chaves reais; use `dart_defines.example.json` como referência para produção.

### 4. Contas demo (seed local)

Senha padrão: **`demo123`**

| Tipo | E-mails |
|------|---------|
| Pessoas | `ana@demo.local`, `bruno@demo.local`, `carla@demo.local` |
| Imóveis | `apt.centro@demo.local`, `casa.jardins@demo.local`, `kit.vila@demo.local` |

Cenário de teste sugerido: **Ana Silva** ↔ match/chat com **Apto Centro**.

---

## Supabase — comandos manuais

Além do `initDev.sh`, estes comandos são úteis no dia a dia (equivalentes com CLI global: troque `npx supabase@latest` por `supabase`):

```bash
# Reseta o banco local e reaplica migrations + seed
npx supabase@latest db reset --local

# Aplica migrations pendentes (sem reset completo)
npx supabase@latest migration up
```

Outros comandos frequentes:

```bash
npx supabase@latest start    # sobe containers locais
npx supabase@latest stop     # para containers
npx supabase@latest status   # API URL, anon key, Studio
```

Migrations: `supabase/migrations/` (001 … 015). Seed: `supabase/seed.sql`.

---

## Supabase remoto (produção / staging)

1. Crie um projeto em [supabase.com](https://supabase.com).
2. Aplique as migrations no projeto remoto (`supabase db push` ou pipeline CI).
3. Copie URL e **anon key** (Settings → API).
4. Crie um arquivo local (não versionado), por exemplo a partir do exemplo:

```bash
cp dart_defines.example.json dart_defines.json
# Edite SUPABASE_URL e SUPABASE_ANON_KEY
```

5. Rode:

```bash
flutter run --dart-define-from-file=dart_defines.json
```

---

## Qualidade de código e testes

Ordem sugerida antes de commit ou PR:

```bash
dart analyze
dart format .
flutter test test/                    # suite completa antes de PR
flutter test test/app/modules/NOME/   # módulo específico
```

Build de validação Android:

```bash
flutter build apk --release
```

---

## Estrutura do projeto (visão geral)

```
mobile/aluga_comigo/
├── lib/
│   ├── main.dart                 # Supabase.init + ModularApp
│   └── app/
│       ├── app_module.dart       # DI raiz e módulos
│       ├── modules/              # features (auth, customer, house, chats, like, …)
│       └── shared/               # serviços Supabase, helpers, widgets
├── supabase/
│   ├── config.toml
│   ├── migrations/
│   └── seed.sql
├── scripts/
│   ├── initDev.sh              # setup local completo
│   └── genDeviceDefines.sh       # celular físico
├── test/                       # espelha lib/app/modules/
├── dart_defines.example.json
└── AGENTS.md                   # mapa de arquitetura e comandos para IA/dev
```

Cada feature em `lib/app/modules/[nome]/` segue **Clean Architecture**: `domain/`, `data/`, `ui/` (ou `presenter/`), `*_module.dart`, `*_di_module.dart`.

---

## Problemas comuns

| Sintoma | O que verificar |
|---------|------------------|
| Erro de conexão Supabase no emulador Android | Use `dart_defines.android.json` (`10.0.2.2`, não `127.0.0.1`) |
| Erro no celular físico | Mesma Wi-Fi, firewall, `./scripts/genDeviceDefines.sh` |
| `AutoInjectorException` / classe DI duplicada | Não registre o mesmo `*_di_module` no `AppModule` e no módulo filho |
| Docker / Supabase não sobe | `docker info`, `supabase status`, portas 54321–54324 livres |
| Migrations desatualizadas | `npx supabase@latest db reset --local` ou `migration up` |

---

## Segurança

- Chaves Supabase via **`--dart-define-from-file`**, nunca hardcoded no código.
- `dart_defines*.json` estão no `.gitignore`.
- O app usa `flutter_secure_storage` e **freerasp** (integridade); não desabilite checks de produção sem motivo.

---

## Licença / versão

Versão do app: ver `version` em [`pubspec.yaml`](./pubspec.yaml) (ex.: `1.0.1+2`).

---

## Referência rápida (comandos que já existiam no README)

```bash
# Reseta o banco e cria as entradas padrão (seed)
npx supabase@latest db reset --local

# Roda para subir as migrations
npx supabase@latest migration up
```
