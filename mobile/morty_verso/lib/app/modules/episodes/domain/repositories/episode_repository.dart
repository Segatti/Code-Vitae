import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/episode.dart';
import '../entities/episodes.dart';

abstract class IEpisodeRepository {
  Future<Either<Failure, Episodes>> getAll(int page);
  Future<Either<Failure, Episode>> getOne(int id);
  Future<Either<Failure, List<Episode>>> getMultiple(List<int> ids);
}
