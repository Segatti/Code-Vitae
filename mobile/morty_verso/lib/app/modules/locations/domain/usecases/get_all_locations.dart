import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/locations.dart';
import '../errors/location_error.dart';
import '../repositories/location_repository.dart';

abstract class IUCGetAllLocations {
  Future<Either<Failure, Locations>> call(int page);
}

class UCGetAllLocations implements IUCGetAllLocations {
  final ILocationRepository locationRepository;

  const UCGetAllLocations({
    required this.locationRepository,
  });

  @override
  Future<Either<Failure, Locations>> call(int page) async {
    if (page < 0) {
      return Left(InvalidInput('UCGetAllLocations - InvalidInput'));
    } else {
      final response = await locationRepository.getAll(page);
      return response.fold(
        (error) => Left(error),
        (response) => (response.results?.isEmpty ?? true)
            ? Left(EmptyList('UCGetAllLocations - EmptyList'))
            : Right(response),
      );
    }
  }
}
