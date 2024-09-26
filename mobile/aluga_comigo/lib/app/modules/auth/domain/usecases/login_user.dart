import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/login_input.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class ILoginUser {
  Future<Return<User>> call(LoginInput input);
}

class LoginUser implements ILoginUser {
  final IAuthRepository repository;

  const LoginUser(this.repository);

  @override
  Future<Return<User>> call(LoginInput input) async {
    return await repository.login(input);
  }
}
