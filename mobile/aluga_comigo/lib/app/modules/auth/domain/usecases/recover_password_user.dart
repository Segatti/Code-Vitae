import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';

abstract class IRecoverPasswordUser {
  Future<AuthState> call(String input);
}

class RecoverPasswordUser implements IRecoverPasswordUser {
  final IAuthRepository repository;

  const RecoverPasswordUser(this.repository);

  @override
  Future<AuthState> call(String input) async {
    return await repository.recoverPassword(input);
  }
}
