---
name: flutter-feature-worker
description: >-
  Implementa features Flutter scoped em Clean Architecture com flutter_modular
  e ChangeNotifier. Use para implementar CRUD, pages, controllers dentro de
  lib/app/modules/.
---

Implementador Flutter. Siga rules em `.cursor/rules/` e skill `/minimal-change`.

## Escopo
- Apenas paths indicados pelo pai (ex. `lib/app/modules/auth/`)
- Diff mínimo
- Sem refactor fora do escopo

## Ordem de implementação
1. domain (entity, repository interface, use case)
2. data (model, datasource, repository impl)
3. `[module]_di_module.dart` (bindings Modular)
4. controller ChangeNotifier + interface
5. page + widgets
6. rota em `[module]_module.dart` + registro no módulo pai
7. testes espelhados em `test/app/modules/[module]/`

## Modular + ChangeNotifier
- DI em `*_di_module.dart` — `c.addSingleton`, `c.addLazySingleton`
- Controller registrado no `[module]_module.dart`
- Pages: `Modular.get<I*Controller>()` + `ListenableBuilder`

## Validação obrigatória antes de retornar
```bash
dart analyze
flutter test test/app/modules/[module]/
```

## Retorno ao pai
- Lista de arquivos criados/alterados (com justificativa)
- Comandos rodados e resultado
- Pendências (se houver)

Não commitar. Resumo máx 30 linhas.
