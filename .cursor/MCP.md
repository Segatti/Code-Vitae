# MCP no Cursor — Code-Vitae / Aluga Comigo

Este repositório expõe servidores **MCP** (Model Context Protocol) para o Agent do Cursor interagir com Dart/Flutter, testes Patrol, app em execução (Marionette) e designs no Figma.

Configuração: [`.cursor/mcp.json`](./mcp.json) na raiz do workspace **Code-Vitae**.

---

## Pré-requisitos gerais

| Item | Versão / nota |
|------|----------------|
| Flutter / Dart | SDK do projeto (`mobile/aluga_comigo`, Dart 3.x) |
| Cursor | MCP habilitado |
| Node.js | `npx` (servidor **figma-flutter**) |
| Workspace | Abrir a pasta **`Code-Vitae`** (não só um subfolder), para o Cursor carregar `.cursor/mcp.json` |

Após editar `mcp.json`: **salvar** e **Reload Window** (`Ctrl+Shift+P` → *Developer: Reload Window*).

---

## Onde ver servidores e tools ativas

| Onde | Para quê |
|------|----------|
| **Sidebar → Customize → MCPs** | Lista servidores, liga/desliga cada um, instala novos |
| **`Ctrl+Shift+P` → Open MCPs** | Atalho para a mesma tela |
| **Chat / Agent → Available Tools** | Tools dos MCPs **ativos**; dá para desligar tool por tool |
| **Output → MCP Logs** (`Ctrl+Shift+U`) | Erros de startup (PATH, API key, `cwd`, etc.) |

Projeto e global são **mesclados**: `~/.cursor/mcp.json` + `.cursor/mcp.json` (nome igual → vence o do projeto).

---

## 1. Dart (`dart`)

**O que faz:** Servidor oficial do SDK Dart — contexto do projeto, análise, pacotes, execução de ferramentas de dev alinhadas ao Flutter/Dart.

**Config (já no repo):**

```json
"dart": {
  "command": "dart",
  "args": ["mcp-server", "--force-roots-fallback"]
}
```

`--force-roots-fallback` contorna limitação do Cursor com *Roots* no protocolo MCP.

### Como usar no Agent

Peça tarefas que dependem do código real do repo, por exemplo:

- *“Rode `dart analyze` em `lib/app/modules/like/` e corrija os erros.”*
- *“Quais packages estão desatualizados no `pubspec`?”*
- *“Explique este erro de análise no arquivo X.”*

O Agent usa as **tools** expostas pelo MCP Dart (nomes exatos aparecem em **Available Tools** quando o servidor está verde).

### Troubleshooting

- Servidor vermelho: confirme `dart --version` no terminal e que o Cursor usa o mesmo SDK (`which dart`).
- Abra o projeto Flutter em `mobile/aluga_comigo` no workspace para o servidor enxergar o package root.

**Referência:** [Dart MCP Server (Flutter blog)](https://flutter.dev/blog/supercharge-your-dart-flutter-development-experience-with-the-dart-mcp-server)

---

## 2. Patrol (`patrol`)

**O que faz:** MCP da [LeanCode Patrol](https://patrol.leancode.co/) — rodar e gerenciar testes E2E/interativos (`patrol develop`, etc.) via Agent.

**Dependência:** `patrol_mcp` em `dev_dependencies` em `mobile/aluga_comigo/pubspec.yaml`.

**Config:** o servidor roda com `dart run patrol_mcp` e `cwd` / `PROJECT_ROOT` apontando para:

`mobile/aluga_comigo`

> **Outra máquina:** ajuste os caminhos absolutos em `mcp.json` para o seu clone local.

### Antes de usar

1. Instale dependências: `cd mobile/aluga_comigo && flutter pub get`
2. Tenha **Patrol CLI / testes** configurados no app quando for rodar E2E de verdade (ver [documentação Patrol](https://patrol.leancode.co/)).
3. Variáveis opcionais no `mcp.json`:
   - `PATROL_FLAGS` — flags extras para o CLI
   - `SHOW_TERMINAL` — `"true"` para ver o terminal do Patrol

### Como usar no Agent

Exemplos de prompt (com MCP Patrol **ativo**):

- *“Liste os targets de teste Patrol deste projeto.”*
- *“Rode o teste Patrol X em modo develop e me diga se passou.”*
- *“Ajude a criar um teste Patrol para o fluxo de login.”*

As tools disponíveis dependem da versão do `patrol_mcp` (0.2.x no projeto) e do `patrol`/`patrol_cli` compatíveis.

### Troubleshooting

- Falha ao iniciar: confira `cwd` e `PROJECT_ROOT` no `mcp.json`.
- Conflito de versão: veja [compatibilidade patrol_mcp ↔ patrol](https://patrol.leancode.co/documentation/other/patrol-mcp).

---

## 3. Marionette (`marionette`)

**O que faz:** Controla um **app Flutter em debug** (tap, scroll, texto, screenshot, árvore de widgets) via VM Service — “browser automation” para Flutter.

**Binário:** `marionette_mcp` (instalação global):

```bash
dart pub global activate marionette_mcp
```

Garanta `~/.pub-cache/bin` no `PATH` do Cursor **ou** use o caminho absoluto no `mcp.json` (como no repo).

### Preparar o app (obrigatório para interagir)

Hoje o `main.dart` **não** inclui Marionette. Para o MCP funcionar com o app, em **debug**:

1. Adicione dependência: `flutter pub add marionette_flutter`
2. No `main.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

void main() async {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  // ... resto (Supabase, runApp, etc.)
}
```

3. Rode: `flutter run` (emulador ou device).
4. No console, copie o **VM Service URI**, ex.: `ws://127.0.0.1:45678/ws`.

### Como usar no Agent

Com Marionette ativo e app rodando:

- *“Conecte ao VM Service `ws://127.0.0.1:…/ws`.”*
- *“Mostre a árvore de widgets.”*
- *“Toque no botão ‘Iniciar conversa’ e tire um screenshot.”*

### Troubleshooting

- MCP sobe mas não conecta: app não está em debug ou `MarionetteBinding` não foi inicializado.
- Comando não encontrado: reinstale `marionette_mcp` e atualize o path em `mcp.json`.

**Referência:** [Marionette MCP](https://marionette.leancode.co/)

---

## 4. Figma Flutter (`figma-flutter`)

**O que faz:** Lê arquivos Figma (via **Personal Access Token**) para o Agent implementar UI em Flutter com tokens, cores, tipografia e estrutura do design.

**Config:**

```json
"figma-flutter": {
  "command": "npx",
  "args": ["-y", "figma-flutter-mcp", "--stdio"],
  "env": {
    "FIGMA_API_KEY": ""
  }
}
```

### Configurar API key (obrigatório)

1. Figma → **Settings** → [Personal access tokens](https://www.figma.com/developers/api#access-tokens)
2. Crie um token (escopo de leitura de arquivos que você usa)
3. Cole em **Customize → MCPs → figma-flutter → Environment**  
   **ou** em `FIGMA_API_KEY` no `mcp.json` (**não commite** a chave real)

### Como usar no Agent

Tenha em mãos a **URL do arquivo** Figma (com `fileKey`) e, se preciso, o **node id** do frame:

- *“Use o MCP Figma no arquivo `https://www.figma.com/design/FILE_KEY/...` e gere o layout da tela de login em Flutter seguindo o design system do Aluga Comigo.”*
- *“Extraia cores e espaçamentos do frame X e aplique em `auth_page.dart` usando `.w()` / `.h()`.”*

Combine com as regras de layout do app (`DesignScreen` 390×844 — ver `design_screen_config.dart`).

### Troubleshooting

- Servidor falha: `FIGMA_API_KEY` vazio ou token revogado.
- `npx` lento na primeira vez: normal; MCP Logs mostram download do pacote.
- Arquivo privado: token da conta com acesso ao file.

**Pacote:** [figma-flutter-mcp no npm](https://www.npmjs.com/package/figma-flutter-mcp)

---

## Resumo rápido

| MCP | Quando usar |
|-----|-------------|
| **dart** | Análise, pub, dev tools, entender/corrigir código Dart |
| **patrol** | Testes E2E Patrol, `patrol develop`, automação de QA |
| **marionette** | App rodando em debug — tap, scroll, widget tree, screenshots |
| **figma-flutter** | Design → Flutter a partir de arquivos Figma |

---

## Segurança

- Não coloque **FIGMA_API_KEY**, chaves Supabase de produção ou secrets reais no `mcp.json` versionado.
- MCPs rodam **localmente** no seu Cursor; tokens Figma saem só para a API da Figma quando você usa esse servidor.

---

## Ajustar caminhos (novo clone / outro SO)

Edite em [`.cursor/mcp.json`](./mcp.json):

- `patrol` → `cwd` e `env.PROJECT_ROOT` → pasta `mobile/aluga_comigo` no seu disco
- `marionette` → `command` → saída de `which marionette_mcp` ou `~/.pub-cache/bin/marionette_mcp`

Depois: Reload Window e confira **MCP Logs**.
