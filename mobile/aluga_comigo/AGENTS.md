# AGENTS.md — Flutter Mobile Clean Architecture

Mapa para humanos e agentes de IA.

> **Arquitetura obrigatória: Clean Architecture.** Todo código segue camadas `domain` → `data` → `presenter/ui` com regra de dependência unidirecional. Rule Cursor: `.cursor/rules/clean-architecture.mdc` (alwaysApply).

---

## Stack

- Flutter 3.x (Mobile — Android/iOS)
- Dart 3.x (strict analysis)
- Roteamento + DI: **flutter_modular** v7
- Estado UI: **ChangeNotifier** controllers (`I*Controller`)
- Erros: **dartz** (`Either<Failure, T>`) + result_dart
- Backend: Firebase (Auth, Firestore, Storage)
- Tests: flutter_test, mocktail

---

## Arquitetura

```
presenter/ui → domain ← data
```

| Camada | Responsabilidade | Pode importar |
|--------|------------------|---------------|
| **domain** | Entities, UseCases, Repository interfaces | shared/domain apenas |
| **data** | Models, DataSources, Repository impl | domain, shared |
| **presenter/ui** | UI, controllers, widgets | domain, shared |
| **shared** | Services Firebase, helpers, transitions | nada de modules |

---

## Estrutura de módulo

```
lib/app/modules/[nome]/
├── [nome]_module.dart          # rotas + bind controller
├── [nome]_di_module.dart       # DI Modular
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presenter/  (ou ui/)
    ├── controllers/
    ├── pages/
    └── widgets/
```

Testes espelham em `test/app/modules/[nome]/`.

---

## Modular + ChangeNotifier — padrões

| Caso | Usar |
|------|------|
| Injetar use case / repo | `*_di_module.dart` com `c.addSingleton` / `c.addLazySingleton` |
| Estado de tela | Controller `ChangeNotifier` + interface `I*Controller` |
| UI rebuild | `ListenableBuilder(listenable: controller, ...)` |
| Obter controller | `Modular.get<I*Controller>()` na page |
| Nova rota | `[module]_module.dart` + registro no módulo pai |
| Helpers compartilhados | `lib/app/shared/domain/helpers/` (só se 2+ usos) |

---

## Diff mínimo (obrigatório)

Skill `/minimal-change` — auto-invoca em toda implementação:

> sempre simplifique as alterações para o minimo de alteração para atingir o objetivo pedido e somente deve ser refatorado quando uma logica só usada em varios pontos do sistema e deve ser um helper

---

## Comandos

| Comando | Quando |
|---------|--------|
| `dart analyze` | Sempre após edits |
| `dart format .` | Antes de commit |
| `flutter test test/app/modules/X/` | Módulo em progresso |
| `flutter test` | Antes de PR |
| `flutter build apk --release` | Validar build Android |

---

## Rules Cursor

| Arquivo | Escopo |
|---------|--------|
| `clean-architecture.mdc` | **alwaysApply** — arquitetura obrigatória |
| `core.mdc` | alwaysApply |
| `flutter.mdc` | `**/*.dart` |
| `domain-layer.mdc` | `**/domain/**` |
| `data-layer.mdc` | `**/data/**` |
| `presentation-layer.mdc` | `**/presenter/**`, `**/ui/**` |
| `flutter-mobile.mdc` | `lib/**` |

---

## Skills

| Skill | Uso |
|-------|-----|
| `/minimal-change` | **Sempre** — diff mínimo, helper só com 2+ usos |
| `/scaffold-module` | Criar módulo Clean Architecture completo |
| `/pr-review` | Review antes de PR |
| `/fix-ci` | CI/analyze falhou |
| `/widget-test` | Testes de widget/controller |
| `/project-audit-report` | Audit → bugs, melhorias, mercado → `.md` em `docs/reports/` |

---

## Subagents

| Agent | Uso |
|-------|-----|
| `flutter-architect` | Decisões de arquitetura, SOLID |
| `flutter-feature-worker` | Implementar módulo scoped |
| `architecture-reviewer` | Review readonly de camadas |
| `project-insights-reviewer` | Bugs, melhorias, insights de mercado (readonly) |

---

## Hooks (automação)

| Hook | Função |
|------|--------|
| `block-dangerous.sh` | Bloqueia comandos destrutivos e push não autorizado |
| `flutter-command-guard.sh` | Sugere analyze antes de suite completa |
| `dart-format-on-edit.sh` | Formata `.dart` após edição |
| `scan-secrets.sh` | Alerta secrets no prompt |
| `suggest-analyze.sh` | Sugere corrigir erros de analyze ao final |

---

## Relatórios para IA

Gerados em `docs/reports/`. Anexar em prompts: `@docs/reports/YYYY-MM-DD-*-audit.md`

---

## Flutter Mobile — checklist

- [ ] SafeArea e teclado (`resizeToAvoidBottomInset`) em formulários
- [ ] Permissões via `permission_handler` antes de câmera/localização
- [ ] Listas com `ListView.builder` / lazy loading
- [ ] Imagens remotas com `cached_network_image`
- [ ] Sem lógica de negócio em widgets — UseCase + Controller
- [ ] Sem Riverpod / go_router / get_it — usar flutter_modular

---

## Proibido

- Import circular entre camadas
- `domain` importando `data` ou `presenter/ui`
- Widgets com chamada Firebase/HTTP direta
- God classes / widgets > 200 linhas sem extrair
- Refactor fora do escopo do pedido
- Helper com uso único
- Commit/push sem pedido explícito do usuário
