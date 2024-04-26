import '../entities/inputs/signup_user_input.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';

abstract class ISignupUser {
  Future<AuthState> call(SignupUserInput input);
}

class SignupUser implements ISignupUser {
  final IAuthRepository repository;

  const SignupUser(this.repository);

  @override
  Future<AuthState> call(SignupUserInput input) async {
    return await repository.signupUser(input);
  }
}
