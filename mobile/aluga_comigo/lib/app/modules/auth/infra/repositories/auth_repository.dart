import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_immobile_input.dart';
import '../../domain/entities/inputs/signup_user_input.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/states/auth_state.dart';
import '../datasources/auth_datasource.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDatasource datasource;

  const AuthRepository(this.datasource);

  @override
  Future<AuthState> login(LoginInput input) async {
    try {
      final response = await datasource.login(input);
      return response;
    } on Exception catch (e) {
      return ErrorState(
        "Specific",
        e.toString(),
      );
    } catch (e, s) {
      print(s);
      return ErrorState(
        "Generic",
        e.toString(),
      );
    }
  }

  @override
  Future<AuthState> recoverPassword(String input) async {
    try {
      final response = await datasource.recoverPassword(input);
      return response;
    } on Exception catch (e) {
      return ErrorState(
        "Specific",
        e.toString(),
      );
    } catch (e) {
      return ErrorState(
        "Generic",
        e.toString(),
      );
    }
  }

  @override
  Future<AuthState> signupImmobile(SignupImmobileInput input) async {
    try {
      final response = await datasource.signupImmobile(input);
      return response;
    } on Exception catch (e) {
      return ErrorState(
        "Specific",
        e.toString(),
      );
    } catch (e) {
      return ErrorState(
        "Generic",
        e.toString(),
      );
    }
  }

  @override
  Future<AuthState> signupUser(SignupUserInput input) async {
    try {
      final response = await datasource.signupUser(input);
      return response;
    } on Exception catch (e) {
      return ErrorState(
        "Specific",
        e.toString(),
      );
    } catch (e) {
      return ErrorState(
        "Generic",
        e.toString(),
      );
    }
  }
}
