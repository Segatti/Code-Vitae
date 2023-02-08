import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/core/domain/usecases/get_value_local_storage.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/errors/local_storage_error.dart';

abstract class IUCGetFavoriteCharacters {
  Future<Either<Failure, List<String>>> call();
}

class UCGetFavoriteCharacters implements IUCGetFavoriteCharacters {
  final IUCGetValueLocalStorage getValueLocalStorage;

  const UCGetFavoriteCharacters({required this.getValueLocalStorage});

  @override
  Future<Either<Failure, List<String>>> call() async {
    try {
      final result = await getValueLocalStorage('favorite_characters');
      List<String> characterIdList = [];
      return result.fold(
        (l) => Left(l),
        (r) {
          if (r != null) {
            characterIdList =
                (json.decode(r) as List).map((e) => e.toString()).toList();
          }
          return Right(characterIdList);
        },
      );
    } catch (e) {
      return Left(ItemValueError('UCGetFavoriteCharacters - ItemValueError'));
    }
  }
}
