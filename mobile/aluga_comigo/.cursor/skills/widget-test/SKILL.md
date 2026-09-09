---
name: widget-test
description: >-
  Cria ou corrige widget tests e ChangeNotifier controller tests Flutter.
  Use para testes de UI, presentation, Modular DI, golden tests.
disable-model-invocation: true
---

# Widget / Presentation Tests (ChangeNotifier + Modular)

## O que testar

| Alvo | Tipo | Ferramenta |
|------|------|------------|
| UseCase | Unit | flutter_test + mocktail |
| Controller | Unit | mock use cases + ChangeNotifier |
| Page/Widget | Widget | Modular.bindModule + pumpWidget |
| Golden | Optional | matchesGoldenFile |

## Template Controller test

```dart
void main() {
  late MockILoginUser mockLoginUser;
  late AuthController controller;

  setUp(() {
    mockLoginUser = MockILoginUser();
    controller = AuthController(mockLoginUser, /* outros mocks */);
  });

  test('deve retornar false e setar errorMessage quando login falha', () async {
    when(() => mockLoginUser(any()))
        .thenAnswer((_) async => Left(tFailure));

    final result = await controller.login(tLoginInput);

    expect(result, false);
    expect(controller.errorMessage, isNotEmpty);
  });
}
```

## Template Widget test

```dart
testWidgets('shows error message when login fails', (tester) async {
  final mockController = MockIAuthController();
  when(() => mockController.errorMessage).thenReturn('Erro');
  when(() => mockController.login(any())).thenAnswer((_) async => false);

  await tester.pumpWidget(
    MaterialApp(
      home: ListenableBuilder(
        listenable: mockController,
        builder: (_, __) => AuthView(
          errorMessage: mockController.errorMessage,
          onLogin: mockController.login,
        ),
      ),
    ),
  );

  expect(find.text('Erro'), findsOneWidget);
});
```

## Com Modular (integração)

```dart
setUp(() {
  Modular.bindModule(AuthDiModule());
  Modular.replaceInstance<IAuthController>(mockController);
});

tearDown(() {
  Modular.destroy();
});
```

## Regras
- Mock **interfaces** do domain (`ILoginUser`, `IAuthRepository`)
- Um comportamento principal por teste
- Nome: `'deve X quando Y'`
- Preferir testar `AuthView` (UI pura) over page completa quando possível
- Sempre `tearDown` / `Modular.destroy()` após testes com DI

## Validação
```bash
flutter test test/app/modules/[module]/
```
