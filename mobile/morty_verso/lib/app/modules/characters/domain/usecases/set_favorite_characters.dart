import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/errors/local_storage_error.dart';
import '../../../../core/domain/usecases/set_value_local_storage.dart';

abstract class IUCSetFavoriteCharacters {
  Future<Either<Failure, void>> call(
      String key, List<String> characterIdList);
}

class UCSetFavoriteCharacters implements IUCSetFavoriteCharacters {
  final IUCSetValueLocalStorage setValueLocalStorage;

  const UCSetFavoriteCharacters({required this.setValueLocalStorage});

  @override
  Future<Either<Failure, void>> call(
      String key, List<String> characterIdList) async {
    try {
      if (key.isNotEmpty) {
        String source = json.encode(characterIdList);
        setValueLocalStorage(key, source);
        return const Right(null);
      } else {
        return Left(KeyError('UCSetFavoriteCharacters - KeyError'));
      }
    } catch (e) {
      return Left(ItemValueError('UCSetFavoriteCharacters - ItemValueError'));
    }
  }
}
