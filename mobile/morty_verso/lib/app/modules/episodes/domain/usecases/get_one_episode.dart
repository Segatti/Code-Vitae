import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/episode.dart';
import '../errors/episode_error.dart';
import '../repositories/episode_repository.dart';

abstract class IUCGetOneEpisode {
  Future<Either<Failure, Episode>> call(int id);
}

class UCGetOneEpisode implements IUCGetOneEpisode {
  final IEpisodeRepository EpisodeRepository;

  const UCGetOneEpisode({
    required this.EpisodeRepository,
  });

  @override
  Future<Either<Failure, Episode>> call(int id) async {
    if (id < 0) {
      return Left(InvalidInput('UCGetOneEpisode - InvalidInput'));
    } else {
      final response = await EpisodeRepository.getOne(id);
      return response.fold(
        (error) => Left(error),
        (response) => Right(response),
      );
    }
  }
}
