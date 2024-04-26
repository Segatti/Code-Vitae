import '../../../../shared/data/services/firebase_auth_service.dart';
import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../../shared/data/services/firebase_storage_service.dart';
import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_immobile_input.dart';
import '../../domain/entities/inputs/signup_user_input.dart';
import '../../domain/entities/user.dart';
import '../../domain/enums/type_user.dart';
import '../../domain/states/auth_state.dart';
import '../../infra/datasources/auth_datasource.dart';

class AuthFirebaseDatasource implements IAuthDatasource {
  final FirebaseAuthService auth;
  final FirebaseDatabaseService database;
  final FirebaseStorageService storage;

  const AuthFirebaseDatasource(this.auth, this.database, this.storage);

  @override
  Future<AuthState> login(LoginInput input) async {
    final response = await auth.login(input.email, input.password);
    return await response.fold((l) {
      throw Exception("Error: login.auth.login - ${l.message}");
    }, (r) async {
      final data = await database.read(FirebaseDataTables.users, r.user!.uid);
      return await data.fold((l) {
        throw Exception("Error: login.database.read - $l");
      }, (r2) async {
        final data = r2 as Map;
        var typeUser = getTypeUser(data['typeUser']);

        final User user = User(
          input.email,
          input.password,
          typeUser,
          data['photos'][0],
        );
        return LoginSuccessState(user);
      });
    });
  }

  @override
  Future<AuthState> recoverPassword(String input) async {
    final response = await auth.recoverPassword(input);
    return await response.fold((l) {
      throw Exception(
          "Error: recoverPassword.auth.recoverPassword - ${l.message}");
    }, (_) async {
      return RecoverSuccessState();
    });
  }

  @override
  Future<AuthState> signupImmobile(SignupImmobileInput input) async {
    final response = await auth.createUser(input.email, input.password);
    return await response.fold((l) {
      throw Exception("Error: signupImmobile.auth.createUser - ${l.message}");
    }, (auth) async {
      final responseStorage = await storage.upload(
        FirebaseStorageTables.immobile,
        auth.user!.uid,
        input.photo,
      );

      return await responseStorage.fold((l) {
        throw Exception("Error: signupImmobile.storage.upload - $l");
      }, (linkPhoto) async {
        await database.create(
          FirebaseDataTables.immobile,
          {
            "name": input.name,
            "phone": input.phone,
            "cep": input.cep,
            "value": input.value,
            "typeImmobile": input.typeImmobile.name,
            "photos": [linkPhoto],
          },
        );

        return SignupSuccessState(
          User(input.email, input.password, TypeUser.immobile, linkPhoto),
        );
      });
    });
  }

  @override
  Future<AuthState> signupUser(SignupUserInput input) async {
    final response = await auth.createUser(input.email, input.password);
    return await response.fold((l) {
      throw Exception("Error: signupUser.auth.createUser - ${l.message}");
    }, (auth) async {
      final responseStorage = await storage.upload(
        FirebaseStorageTables.users,
        auth.user!.uid,
        input.photo,
      );

      return await responseStorage.fold((l) {
        throw Exception("Error: signupUser.storage.upload - $l");
      }, (linkPhoto) async {
        await database.create(
          FirebaseDataTables.users,
          {
            "name": input.name,
            "phone": input.phone,
            "skills": input.skills,
            "photos": [linkPhoto],
          },
        );

        return SignupSuccessState(
          User(
            input.email,
            input.password,
            TypeUser.person,
            linkPhoto,
          ),
        );
      });
    });
  }
}
