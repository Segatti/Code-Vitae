import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/episodes.dart';
import '../../domain/errors/episode_error.dart';
import '../../domain/repositories/episode_repository.dart';
import '../datasources/api_datasource.dart';

class EpisodeRepository implements IEpisodeRepository {
  final IApiDatasource apiDatasource;

  const EpisodeRepository({
    required this.apiDatasource,
  });

  @override
  Future<Either<Failure, Episodes>> getAll(int page) async {
    try {
      final response = await apiDatasource.getAll(page);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('EpisodeRepository.getAll - DatasourceError - $e'));
    }
  }

  @override
  Future<Either<Failure, Episode>> getOne(int id) async {
    try {
      final response = await apiDatasource.getOne(id);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('EpisodeRepository.getOne - DatasourceError'));
    }
  }

  @override
  Future<Either<Failure, List<Episode>>> getMultiple(List<int> ids) async {
    try {
      final response = await apiDatasource.getMultiple(ids);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('EpisodeRepository.getMultiple - DatasourceError'));
    }
  }
}
