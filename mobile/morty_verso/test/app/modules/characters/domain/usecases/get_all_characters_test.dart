import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/core/domain/errors/failure.dart';
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

  test('Deve buscar os personagens com sucesso', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Characters(results: [Character()])),
    );

    expect(await usecase(1), isA<Right>());
  });

  test('Deve buscar os personagens com erro', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Characters(results: [])),
    );

    expect(await usecase(1), isA<Left>());
  });
}
