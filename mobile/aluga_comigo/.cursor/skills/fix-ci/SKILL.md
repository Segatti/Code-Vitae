---
name: fix-ci
description: >-
  Corrige falhas de dart analyze, format ou flutter test CI.
  Use quando pipeline falhar, analyze vermelho, ou lint errors.
disable-model-invocation: true
---

# Fix CI — Flutter Mobile

## Processo

1. Identificar **primeiro erro** no log (ignorar cascata)
2. Classificar:
   - **analyze** → tipo/nullable/imports
   - **format** → `dart format .`
   - **test** → teste específico que falhou
3. Fix **mínimo** respeitando camadas Clean Architecture (skill `/minimal-change`)
4. Validar em cascata:
   ```bash
   dart analyze
   dart format --set-exit-if-changed .
   flutter test [caminho/do/teste_que_falhou.dart]
   ```
5. Parar — não rodar suite completa unless usuário pedir

## Erros comuns Flutter Mobile

| Erro | Fix típico |
|------|------------|
| Modular binding missing | registrar em `*_di_module.dart` |
| Missing const | adicionar const |
| Layer violation | mover código para camada correta |
| Mock missing | mocktail no test, mock interface domain |
| Permission not granted | tratar retorno de `permission_handler` |

## Proibido
- `@override` suppressions em massa
- Desabilitar rules no analysis_options para "passar"
- Refactor oportunista fora do escopo do CI fix
