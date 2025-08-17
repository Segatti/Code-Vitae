import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/signup_input.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class ISignupUser {
  Future<Return<User>> call(SignupUserInput input);
}

class SignupUser implements ISignupUser {
  final IAuthRepository repository;
  final SecureStorageService storage;

  const SignupUser(this.repository, this.storage);

  @override
  Future<Return<User>> call(SignupUserInput input) async {
    final response = await repository.signupUser(input);

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
