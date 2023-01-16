import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';
import 'package:morty_verso/app/modules/characters/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/characters/infra/models/character_model.dart';
import 'package:morty_verso/app/modules/characters/infra/models/characters_model.dart';
import 'package:morty_verso/app/modules/characters/infra/repositories/character_repository.dart';

import 'character_repository_test.mocks.dart';

@GenerateMocks([RickMortyDatasource])
void main() {
  final datasource = MockRickMortyDatasource();
  final repository = CharacterRepository(apiDatasource: datasource);

  group('Sucessos', () {
    test('Buscar todos os personagens pelo Datasource', () async {
      when(datasource.getAll(any)).thenAnswer((_) async => const CharactersModel());

      final result = await repository.getAll(1);
      expect(result.fold(id, id), isA<CharactersModel>());
    });

    test('Buscar um personagem pelo Datasource', () async {
      when(datasource.getOne(any)).thenAnswer((_) async => const CharacterModel());

      final result = await repository.getOne(1);
      expect(result.fold(id, id), isA<CharacterModel>());
    });
  });

  group('Erros', () {
    test('Erro no Datasource ao tentar buscar todos os personagens',
        () async {
      when(datasource.getAll(any)).thenThrow((_) async => DatasourceError());

      final result = await repository.getAll(1);
      expect(result.fold(id, id), isA<DatasourceError>());
    });

    test('Erro no Datasource ao tentar buscar um personagem', () async {
      when(datasource.getOne(any)).thenThrow((_) async => DatasourceError());

      final result = await repository.getOne(1);
      expect(result.fold(id, id), isA<DatasourceError>());
    });
  });
}
