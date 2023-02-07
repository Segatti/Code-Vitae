import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';
import 'package:morty_verso/app/app_module.dart';
import 'package:morty_verso/app/modules/episodes/domain/entities/episode.dart';
import 'package:morty_verso/app/modules/episodes/domain/entities/episodes.dart';
import 'package:morty_verso/app/modules/episodes/domain/usecases/get_all_episodes.dart';
import 'package:morty_verso/app/modules/episodes/domain/usecases/get_one_episode.dart';
import 'package:morty_verso/app/modules/episodes/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/episodes/infra/repositories/episode_repository.dart';
import 'package:morty_verso/app/modules/episodes/locations_module.dart';

import '../../utils/json_response.dart';
import 'episode_module_test.mocks.dart';

@GenerateMocks([Dio, EpisodeRepository, RickMortyDatasource])
void main() {
  final dio = MockDio();

  initModules(
    [
      AppModule(),
      EpisodesModule(),
    ],
    replaceBinds: [
      Bind.singleton<Dio>((i) => dio),
    ],
  );

  /// Só caso de sucesso, pois as todas as falhas ja são testadas em outros arquivos

  group('Sucessos', () {
    test('Buscar todos os episodios', () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(allEpisodes),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final usecase = Modular.get<IUCGetAllEpisodes>();
      final result = await usecase(1);

      expect(result, isA<dartz.Right>());
      expect(result.fold((l) => l, (r) => r), isA<Episodes>());
    });

    test('Buscar um episodio', () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(oneEpisode),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final usecase = Modular.get<IUCGetOneEpisode>();
      final result = await usecase(1);

      expect(result, isA<dartz.Right>());
      expect(result.fold((l) => l, (r) => r), isA<Episode>());
    });
  });
}
