import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/location.dart';
import '../errors/location_error.dart';
import '../repositories/location_repository.dart';

abstract class IUCGetOneLocation {
  Future<Either<Failure, Location>> call(int id);
}

class UCGetOneLocation implements IUCGetOneLocation {
  final ILocationRepository locationRepository;

  const UCGetOneLocation({
    required this.locationRepository,
  });

  @override
  Future<Either<Failure, Location>> call(int id) async {
    if (id < 0) {
      return Left(InvalidInput('UCGetOneLocation - InvalidInput'));
    } else {
      final response = await locationRepository.getOne(id);
      return response.fold(
        (error) => Left(error),
        (response) => Right(response),
      );
    }
  }
}
