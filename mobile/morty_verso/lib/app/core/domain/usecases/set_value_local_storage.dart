import 'package:dartz/dartz.dart';

import '../errors/failure.dart';
import '../errors/local_storage_error.dart';
import '../services/local_storage_service.dart';

abstract class IUCSetValueLocalStorage {
  Future<Either<Failure, void>> call(String key, String value);
}

class UCSetValueLocalStorage implements IUCSetValueLocalStorage {
  final ILocalStorageService localStorageService;

  const UCSetValueLocalStorage({required this.localStorageService});

  @override
  Future<Either<Failure, void>> call(String key, String value) async {
    try {
      if (key.isNotEmpty) {
        localStorageService.set(key, value);
        return const Right(null);
      } else {
        return Left(KeyError('UCSetValueLocalStorage - KeyError'));
      }
    } catch (e) {
      return Left(ServiceError('UCSetValueLocalStorage - ServiceError'));
    }
  }
}
