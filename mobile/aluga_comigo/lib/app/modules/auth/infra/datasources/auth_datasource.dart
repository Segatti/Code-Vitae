import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_immobile_input.dart';
import '../../domain/entities/inputs/signup_user_input.dart';
import '../../domain/states/auth_state.dart';

abstract class IAuthDatasource {
  Future<AuthState> login(LoginInput input);
  Future<AuthState> signupUser(SignupUserInput input);
  Future<AuthState> signupImmobile(SignupImmobileInput input);
  Future<AuthState> recoverPassword(String input);
}
