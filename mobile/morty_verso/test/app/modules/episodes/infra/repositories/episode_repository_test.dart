import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/episodes/domain/errors/episode_error.dart';
import 'package:morty_verso/app/modules/episodes/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/episodes/infra/models/episode_model.dart';
import 'package:morty_verso/app/modules/episodes/infra/models/episodes_model.dart';
import 'package:morty_verso/app/modules/episodes/infra/repositories/episode_repository.dart';

import 'episode_repository_test.mocks.dart';

@GenerateMocks([RickMortyDatasource])
void main() {
  final datasource = MockRickMortyDatasource();
  final repository = EpisodeRepository(apiDatasource: datasource);

  group('Sucessos', () {
    test('Buscar todos os locais pelo Datasource', () async {
      when(datasource.getAll(any)).thenAnswer((_) async => const EpisodesModel());

      final result = await repository.getAll(1);
      expect(result.fold(id, id), isA<EpisodesModel>());
    });

    test('Buscar um local pelo Datasource', () async {
      when(datasource.getOne(any)).thenAnswer((_) async => EpisodeModel());

      final result = await repository.getOne(1);
      expect(result.fold(id, id), isA<EpisodeModel>());
    });
  });

  group('Erros', () {
    test('Erro no Datasource ao tentar buscar todos os locais',
        () async {
      when(datasource.getAll(any)).thenThrow((_) async => DatasourceError(''));

      final result = await repository.getAll(1);
      expect(result.fold(id, id), isA<DatasourceError>());
    });

    test('Erro no Datasource ao tentar buscar um local', () async {
      when(datasource.getOne(any)).thenThrow((_) async => DatasourceError(''));

      final result = await repository.getOne(1);
      expect(result.fold(id, id), isA<DatasourceError>());
    });
  });
}
