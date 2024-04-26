import '../entities/inputs/login_input.dart';
import '../entities/inputs/signup_immobile_input.dart';
import '../entities/inputs/signup_user_input.dart';
import '../states/auth_state.dart';

abstract class IAuthRepository {
  Future<AuthState> login(LoginInput input);
  Future<AuthState> signupUser(SignupUserInput input);
  Future<AuthState> signupImmobile(SignupImmobileInput input);
  Future<AuthState> recoverPassword(String input);
}
