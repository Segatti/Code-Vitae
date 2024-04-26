import '../entities/inputs/signup_immobile_input.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';

abstract class ISignupImmobile {
  Future<AuthState> call(SignupImmobileInput input);
}

class SignupImmobile implements ISignupImmobile {
  final IAuthRepository repository;

  const SignupImmobile(this.repository);

  @override
  Future<AuthState> call(SignupImmobileInput input) async {
    return await repository.signupImmobile(input);
  }
}
