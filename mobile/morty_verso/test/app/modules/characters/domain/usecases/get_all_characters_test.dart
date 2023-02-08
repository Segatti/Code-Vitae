import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/characters.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_all_characters.dart';
import 'package:morty_verso/app/modules/characters/infra/repositories/character_repository.dart';

import 'get_all_characters_test.mocks.dart';

@GenerateMocks([CharacterRepository])
void main() {
  final repository = MockCharacterRepository();
  final usecase = UCGetAllCharacters(characterRepository: repository);

  test('Sucesso: Buscar todos os personagens', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Characters(results: [Character()])),
    );

    final result = await usecase(1);

    expect(result.fold(id, id), isA<Characters>());
  });

  test('Erro: Lista vazia', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Characters(results: [])),
    );

    final result = await usecase(1);

    expect(result.fold(id, id), isA<EmptyList>());
  });

  test('Erro: Input Invalido', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Characters()),
    );

    final result = await usecase(-1);

    expect(result.fold(id, id), isA<InvalidInput>());
  });
}
