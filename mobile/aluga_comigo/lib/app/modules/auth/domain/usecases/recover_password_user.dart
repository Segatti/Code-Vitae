import '../../../../shared/domain/typedefs/returns.dart';
import '../repositories/auth_repository.dart';

abstract class IRecoverPasswordUser {
  Future<Return<bool>> call(String input);
}

class RecoverPasswordUser implements IRecoverPasswordUser {
  final IAuthRepository repository;

  const RecoverPasswordUser(this.repository);

  @override
  Future<Return<bool>> call(String input) async {
    return await repository.recoverPassword(input);
  }
}
