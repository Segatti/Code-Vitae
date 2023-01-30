import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/errors/local_storage_error.dart';
import '../../../../core/domain/usecases/set_value_local_storage.dart';

abstract class IUCSetFavoriteLocations {
  Future<Either<Failure, void>> call(String key, List<String> locationIdList);
}

class UCSetFavoriteLocations implements IUCSetFavoriteLocations {
  final IUCSetValueLocalStorage setValueLocalStorage;

  const UCSetFavoriteLocations({required this.setValueLocalStorage});

  @override
  Future<Either<Failure, void>> call(
      String key, List<String> locationIdList) async {
    try {
      if (key.isNotEmpty) {
        String source = json.encode(locationIdList);
        setValueLocalStorage(key, source);
        return const Right(null);
      } else {
        return Left(KeyError('UCSetFavoriteLocations - KeyError'));
      }
    } catch (e) {
      return Left(ItemValueError('UCSetFavoriteLocations - ItemValueError'));
    }
  }
}
