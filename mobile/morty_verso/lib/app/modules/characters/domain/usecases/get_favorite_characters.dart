import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/services/local_storage_service.dart';
import '../errors/local_storage_error.dart';

abstract class IUCGetFavoriteCharacters {
  Future<Either<Failure, List<String>>> call(String key);
}

class UCGetFavoriteCharacters implements IUCGetFavoriteCharacters {
  final ILocalStorageService localStorageService;

  const UCGetFavoriteCharacters({required this.localStorageService});

  @override
  Future<Either<Failure, List<String>>> call(String key) async {
    try {
      if (key.isNotEmpty) {
        final result = await localStorageService.get(key);
        List<String> characterIdList = [];
        if (result != null) {
          characterIdList =
              (json.decode(result) as List).map((e) => e.toString()).toList();
        }
        return Right(characterIdList);
      } else {
        return Left(KeyError('UCGetFavoriteCharacters - KeyError'));
      }
    } catch (e) {
      return Left(ItemValueError('UCGetFavoriteCharacters - ItemValueError'));
    }
  }
}
