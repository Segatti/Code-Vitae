import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/core/domain/usecases/get_value_local_storage.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/errors/local_storage_error.dart';

abstract class IUCGetFavoriteLocations {
  Future<Either<Failure, List<String>>> call();
}

class UCGetFavoriteLocations implements IUCGetFavoriteLocations {
  final IUCGetValueLocalStorage getValueLocalStorage;

  const UCGetFavoriteLocations({required this.getValueLocalStorage});

  @override
  Future<Either<Failure, List<String>>> call() async {
    try {
      final result = await getValueLocalStorage('favorite_locations');
      List<String> locationIdList = [];
      return result.fold(
        (l) => Left(l),
        (r) {
          if (r != null) {
            locationIdList =
                (json.decode(r) as List).map((e) => e.toString()).toList();
          }
          return Right(locationIdList);
        },
      );
    } catch (e) {
      return Left(ItemValueError('UCGetFavoriteLocations - ItemValueError'));
    }
  }
}
