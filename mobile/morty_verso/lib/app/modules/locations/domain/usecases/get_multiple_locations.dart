import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/location.dart';
import '../errors/location_error.dart';
import '../repositories/location_repository.dart';

abstract class IUCGetMultipleLocations {
  Future<Either<Failure, List<Location>>> call(List<int> ids);
}

class UCGetMultipleLocations implements IUCGetMultipleLocations {
  final ILocationRepository locationRepository;

  const UCGetMultipleLocations({
    required this.locationRepository,
  });

  @override
  Future<Either<Failure, List<Location>>> call(List<int> ids) async {
    if (ids.isEmpty) {
      return Left(InvalidInput('UCGetMultipleLocations - InvalidInput'));
    } else {
      final response = await locationRepository.getMultiple(ids);
      return response.fold(
        (error) => Left(error),
        (response) => Right(response),
      );
    }
  }
}
