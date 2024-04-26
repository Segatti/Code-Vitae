import '../entities/inputs/login_input.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';

abstract class ILoginUser {
  Future<AuthState> call(LoginInput input);
}

class LoginUser implements ILoginUser {
  final IAuthRepository repository;

  const LoginUser(this.repository);

  @override
  Future<AuthState> call(LoginInput input) async {
    return await repository.login(input);
  }
}
