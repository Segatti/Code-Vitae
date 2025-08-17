import 'package:aluga_comigo/app/shared/data/services/session_service.dart';

import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/login_input.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class ILoginUser {
  Future<Return<User>> call(LoginInput input);
}

class LoginUser implements ILoginUser {
  final IAuthRepository repository;
  final SecureStorageService storage;

  const LoginUser(this.repository, this.storage);

  @override
  Future<Return<User>> call(LoginInput input) async {
    final response = await repository.login(input);

    response.fold(
      (_) {
        SessionService.clearUser();
      },
      (user) async {
        SessionService.setUser(user);
        await storage.setData(StorageKey.user, user.toJson());
      },
    );

    return response;
  }
}
