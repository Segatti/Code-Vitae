import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/episodes/domain/entities/episode.dart';
import 'package:morty_verso/app/modules/episodes/domain/errors/episode_error.dart';
import 'package:morty_verso/app/modules/episodes/domain/usecases/get_one_episode.dart';
import 'package:morty_verso/app/modules/episodes/infra/repositories/episode_repository.dart';

import 'get_one_episode_test.mocks.dart';

@GenerateMocks([EpisodeRepository])
void main() {
  final repository = MockEpisodeRepository();
  final usecase = UCGetOneEpisode(episodeRepository: repository);

  test('Sucesso: Buscar um episodio', () async {
    when(repository.getOne(any))
        .thenAnswer((_) async => const Right(Episode()));

    final result = await usecase(1);
    expect(result.fold(id, id), isA<Episode>());
  });

  test('Error: Id invalido', () async {
    when(repository.getOne(any))
        .thenAnswer((_) async => const Right(Episode()));

    final result = await usecase(-1);
    expect(result.fold(id, id), isA<InvalidInput>());
  });
}
