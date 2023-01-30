import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/location.dart';
import '../entities/locations.dart';

abstract class ILocationRepository {
  Future<Either<Failure, Locations>> getAll(int page);
  Future<Either<Failure, Location>> getOne(int id);
  Future<Either<Failure, List<Location>>> getMultiple(List<int> ids);
}
