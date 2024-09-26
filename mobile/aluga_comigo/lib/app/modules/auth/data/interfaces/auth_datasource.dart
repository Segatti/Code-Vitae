import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_input.dart';
import '../models/user_model.dart';

abstract class IAuthDatasource {
  Future<UserModel> login(LoginInput input);
  Future<UserModel> signupUser(SignupUserInput input);
  Future<UserModel> signupImmobile(SignupImmobileInput input);
  Future<bool> recoverPassword(String input);
}
