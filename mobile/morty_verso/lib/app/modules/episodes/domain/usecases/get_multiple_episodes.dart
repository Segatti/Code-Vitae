import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/episode.dart';
import '../errors/episode_error.dart';
import '../repositories/episode_repository.dart';

abstract class IUCGetMultipleEpisodes {
  Future<Either<Failure, List<Episode>>> call(List<int> ids);
}

class UCGetMultipleEpisodes implements IUCGetMultipleEpisodes {
  final IEpisodeRepository episodeRepository;

  const UCGetMultipleEpisodes({
    required this.episodeRepository,
  });

  @override
  Future<Either<Failure, List<Episode>>> call(List<int> ids) async {
    if (ids.isEmpty) {
      return Left(InvalidInput('UCGetMultipleEpisodes - InvalidInput'));
    } else {
      final response = await episodeRepository.getMultiple(ids);
      return response.fold(
        (error) => Left(error),
        (response) => Right(response),
      );
    }
  }
}
