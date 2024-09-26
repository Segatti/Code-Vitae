import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/signup_input.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class ISignupUser {
  Future<Return<User>> call(SignupUserInput input);
}

class SignupUser implements ISignupUser {
  final IAuthRepository repository;

  const SignupUser(this.repository);

  @override
  Future<Return<User>> call(SignupUserInput input) async {
    return await repository.signupUser(input);
  }
}
