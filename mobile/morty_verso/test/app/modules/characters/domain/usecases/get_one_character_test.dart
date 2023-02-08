import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_one_character.dart';
import 'package:morty_verso/app/modules/characters/infra/repositories/character_repository.dart';

import 'get_all_characters_test.mocks.dart';

@GenerateMocks([CharacterRepository])
void main() {
  final repository = MockCharacterRepository();
  final usecase = UCGetOneCharacter(characterRepository: repository);

  test('Sucesso: Buscar um personagem', () async {
    when(repository.getOne(any))
        .thenAnswer((_) async => const Right(Character()));

    final result = await usecase(1);
    expect(result.fold(id, id), isA<Character>());
  });

  test('Error: Id invalido', () async {
    when(repository.getOne(any))
        .thenAnswer((_) async => const Right(Character()));

    final result = await usecase(-1);
    expect(result.fold(id, id), isA<InvalidInput>());
  });
}
