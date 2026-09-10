---
name: scaffold-module
description: >-
  Cria módulo Flutter completo em Clean Architecture (domain, data, presenter)
  com flutter_modular e ChangeNotifier. Use ao criar nova feature, módulo ou CRUD.
disable-model-invocation: true
---

# Scaffold Module — Clean Architecture + flutter_modular

## Input necessário
- Nome do módulo (snake_case): ex. `user_profile`
- Operações: ex. list, getById, create (mínimo 1)
- Módulo pai para rota: ex. `start_module.dart` ou `app_module.dart`

## Estrutura a criar

```
lib/app/modules/[module]/
├── [module]_module.dart          # rotas + bind controller
├── [module]_di_module.dart       # DI: datasources, repos, use cases
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

test/app/modules/[module]/
├── domain/usecases/
├── data/repositories/
└── presenter/controllers/
```

## Checklist de implementação

- [ ] Entity imutável na domain
- [ ] Repository interface na domain retornando `Either<Failure, T>`
- [ ] UseCase com Single Responsibility + interface `I*UseCase`
- [ ] Model com fromJson/toJson + toEntity() na data
- [ ] Repository impl orquestra datasource
- [ ] `[module]_di_module.dart` registra deps com `c.addSingleton` / `c.addLazySingleton`
- [ ] Controller `ChangeNotifier` + interface `I*Controller`
- [ ] Page com `Modular.get<I*Controller>()` + `ListenableBuilder`
- [ ] `[module]_module.dart` registra DI submodule, controller e rota
- [ ] Registrar módulo no pai: `r.module('/path', module: XModule.new)`
- [ ] `dart analyze` sem erros
- [ ] Testes mínimos: use case unit + controller unit

## Modular checklist
- [ ] DI isolado em `*_di_module.dart`
- [ ] Controller registrado no `[module]_module.dart`
- [ ] Rotas com `AppTransitions` quando aplicável
- [ ] Sem get_it / Riverpod / Bloc

## SOLID checklist
- [ ] Presenter não importa data/ (exceto wiring no di_module)
- [ ] Domain zero imports Flutter
- [ ] Novo comportamento = novo UseCase, não editar 5 classes

## Não fazer
- Gerar módulo sem testes mínimos
- Pular camada domain indo direto Supabase → Controller
- God file com tudo em uma page
- Refactor de módulos existentes fora do escopo

## Validação final
```bash
dart analyze
flutter test test/app/modules/[module]/
```
