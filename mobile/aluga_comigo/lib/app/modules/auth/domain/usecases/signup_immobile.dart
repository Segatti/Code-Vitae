import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/signup_input.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class ISignupImmobile {
  Future<Return<User>> call(SignupImmobileInput input);
}

class SignupImmobile implements ISignupImmobile {
  final IAuthRepository repository;
  final SecureStorageService storage;

  const SignupImmobile(this.repository, this.storage);

  @override
  Future<Return<User>> call(SignupImmobileInput input) async {
    final response = await repository.signupImmobile(input);

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
