import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/core/domain/services/local_storage_service.dart';

import '../errors/failure.dart';
import '../errors/local_storage_error.dart';

abstract class IUCGetValueLocalStorage {
  Future<Either<Failure, String?>> call(String key);
}

class UCGetValueLocalStorage implements IUCGetValueLocalStorage {
  final ILocalStorageService localStorageService;

  const UCGetValueLocalStorage({required this.localStorageService});

  @override
  Future<Either<Failure, String?>> call(String key) async {
    try {
      if (key.isNotEmpty) {
        final result = await localStorageService.get(key);
        return Right(result);
      } else {
        return Left(KeyError('UCGetValueLocalStorage - KeyError'));
      }
    } catch (e) {
      return Left(ServiceError('UCGetValueLocalStorage - ServiceError'));
    }
  }
}
