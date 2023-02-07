import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/episodes/domain/entities/episode.dart';
import 'package:morty_verso/app/modules/episodes/domain/entities/episodes.dart';
import 'package:morty_verso/app/modules/episodes/domain/errors/episode_error.dart';
import 'package:morty_verso/app/modules/episodes/domain/usecases/get_all_episodes.dart';
import 'package:morty_verso/app/modules/episodes/infra/repositories/episode_repository.dart';

import 'get_all_episodes_test.mocks.dart';

@GenerateMocks([EpisodeRepository])
void main() {
  final repository = MockEpisodeRepository();
  final usecase = UCGetAllEpisodes(episodeRepository: repository);

  test('Sucesso: Buscar todos os episodios', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Episodes(results: [Episode()])),
    );

    final result = await usecase(1);

    expect(result.fold(id, id), isA<Episodes>());
  });

  test('Erro: Lista vazia', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Episodes(results: [])),
    );

    final result = await usecase(1);

    expect(result.fold(id, id), isA<EmptyList>());
  });

  test('Erro: Input Invalido', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Episodes()),
    );

    final result = await usecase(-1);

    expect(result.fold(id, id), isA<InvalidInput>());
  });
}
