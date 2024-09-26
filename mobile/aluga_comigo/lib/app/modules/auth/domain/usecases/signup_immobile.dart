import '../../../../shared/domain/typedefs/returns.dart';
import '../entities/inputs/signup_input.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

abstract class ISignupImmobile {
  Future<Return<User>> call(SignupImmobileInput input);
}

class SignupImmobile implements ISignupImmobile {
  final IAuthRepository repository;

  const SignupImmobile(this.repository);

  @override
  Future<Return<User>> call(SignupImmobileInput input) async {
    return await repository.signupImmobile(input);
  }
}
