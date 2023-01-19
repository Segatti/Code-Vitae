import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/services/local_storage_service.dart';
import '../errors/local_storage_error.dart';

abstract class IUCSetFavoriteCharacters {
  Future<Either<Failure, void>> call(
      String key, List<String> characterIdList);
}

class UCSetFavoriteCharacters implements IUCSetFavoriteCharacters {
  final ILocalStorageService localStorageService;

  const UCSetFavoriteCharacters({required this.localStorageService});

  @override
  Future<Either<Failure, void>> call(
      String key, List<String> characterIdList) async {
    try {
      if (key.isNotEmpty) {
        String source = json.encode(characterIdList);
        localStorageService.set(key, source);
        return const Right(null);
      } else {
        return Left(KeyError('UCSetFavoriteCharacters - KeyError'));
      }
    } catch (e) {
      return Left(ItemValueError('UCSetFavoriteCharacters - ItemValueError'));
    }
  }
}
