import '../../../../shared/domain/typedefs/returns.dart';
import '../repositories/auth_repository.dart';

abstract interface class ICheckSignupEmailAvailable {
  Future<Return<bool>> call(String email, String password);
}

class CheckSignupEmailAvailable implements ICheckSignupEmailAvailable {
  const CheckSignupEmailAvailable(this.repository);

  final IAuthRepository repository;

  @override
  Future<Return<bool>> call(String email, String password) =>
      repository.isSignupEmailAvailable(email, password);
}
