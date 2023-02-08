import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/locations.dart';
import '../../domain/errors/location_error.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/api_datasource.dart';

class LocationRepository implements ILocationRepository {
  final IApiDatasource apiDatasource;

  const LocationRepository({
    required this.apiDatasource,
  });

  @override
  Future<Either<Failure, Locations>> getAll(int page) async {
    try {
      final response = await apiDatasource.getAll(page);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('LocationRepository.getAll - DatasourceError - $e'));
    }
  }

  @override
  Future<Either<Failure, Location>> getOne(int id) async {
    try {
      final response = await apiDatasource.getOne(id);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('LocationRepository.getOne - DatasourceError'));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getMultiple(List<int> ids) async {
    try {
      final response = await apiDatasource.getMultiple(ids);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('LocationRepository.getMultiple - DatasourceError'));
    }
  }
}
