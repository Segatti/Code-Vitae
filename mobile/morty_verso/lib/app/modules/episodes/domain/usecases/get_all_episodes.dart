import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/episodes.dart';
import '../errors/episode_error.dart';
import '../repositories/episode_repository.dart';

abstract class IUCGetAllEpisodes {
  Future<Either<Failure, Episodes>> call(int page);
}

class UCGetAllEpisodes implements IUCGetAllEpisodes {
  final IEpisodeRepository EpisodeRepository;

  const UCGetAllEpisodes({
    required this.EpisodeRepository,
  });

  @override
  Future<Either<Failure, Episodes>> call(int page) async {
    if (page < 0) {
      return Left(InvalidInput('UCGetAllEpisodes - InvalidInput'));
    } else {
      final response = await EpisodeRepository.getAll(page);
      return response.fold(
        (error) => Left(error),
        (response) => (response.results?.isEmpty ?? true)
            ? Left(EmptyList('UCGetAllEpisodes - EmptyList'))
            : Right(response),
      );
    }
  }
}
