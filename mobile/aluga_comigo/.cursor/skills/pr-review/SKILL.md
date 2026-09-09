---
name: pr-review
description: >-
  Review estruturado de PR Flutter Clean Architecture: camadas, SOLID, Modular,
  analyze e testes. Use antes de abrir PR, merge, ou code review.
disable-model-invocation: true
---

# PR Review — Flutter Clean Architecture + Modular

## Passos

1. Obter diff: `git diff main...HEAD --stat` e diff dos `.dart` alterados
2. Subagent `architecture-reviewer` readonly no diff
3. Verificar violações de camada manualmente:
   - domain importa data/presentation? → **crítico**
   - presentation importa data impl? → **crítico**
   - lógica de negócio em widget? → **sugestão**
   - bindings Modular faltando ou duplicados? → **sugestão**
4. Flutter Mobile (se presenter/ui/ alterado):
   - permissões tratadas?
   - const widgets onde possível?
   - listas com builder lazy?
5. Diff mínimo: alterações fora do escopo do PR? → **sugestão**
6. `dart analyze` (não suite completa unless pedido)
7. `read_lints` nos arquivos alterados

## Template de output

```markdown
# Review: [título]

## Crítico (bloqueia merge)
- [ ] ...

## Arquitetura / SOLID
- [ ] ...

## Flutter / Mobile
- [ ] ...

## Diff mínimo
- [ ] ...

## Sugestões
- ...

## OK
- ...
```

## Não fazer
- Editar código unless usuário pedir fixes
- Rodar `flutter test` completo no primeiro passo
