import 'package:aluga_comigo/app/modules/auth/domain/entities/user.dart';

import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/login_input.dart';
import '../entities/inputs/signup_input.dart';

abstract class IAuthRepository {
  Future<Return<User>> login(LoginInput input);
  Future<Return<User>> signupUser(SignupUserInput input);
  Future<Return<User>> signupImmobile(SignupImmobileInput input);
  Future<Return<bool>> recoverPassword(String input);
}
