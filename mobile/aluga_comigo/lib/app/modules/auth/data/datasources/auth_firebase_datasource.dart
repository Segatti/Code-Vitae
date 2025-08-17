import 'dart:io';

import '../../../../shared/data/services/firebase_auth_service.dart';
import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../../shared/data/services/firebase_storage_service.dart';
import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_input.dart';
import '../../domain/enums/type_user.dart';
import '../interfaces/auth_datasource.dart';
import '../models/user_model.dart';

class AuthFirebaseDatasource implements IAuthDatasource {
  final FirebaseAuthService auth;
  final FirebaseDatabaseService database;
  final FirebaseStorageService storage;

  const AuthFirebaseDatasource(this.auth, this.database, this.storage);

  @override
  Future<UserModel> login(LoginInput input) async {
    final response = await auth.login(input.email, input.password);
    return await response.fold((l) => throw l, (r) async {
      final data = await database.read(FirebaseDataTables.users, r.user!.uid);
      return await data.fold((l) => throw l, (r2) async {
        final data = r2 as Map;

        return UserModel.fromMap({
          "id": r.user!.uid,
          "email": input.email,
          "password": input.password,
          "typeUser": data['typeUser'],
          "photo": data['photos'][0],
        });
      });
    });
  }

  @override
  Future<bool> recoverPassword(String input) async {
    final response = await auth.recoverPassword(input);
    return await response.fold((l) => throw l, (r) => r);
  }

  @override
  Future<UserModel> signupImmobile(SignupImmobileInput input) async {
    final response = await auth.createUser(input.email, input.password);
    return await response.fold((l) => throw l, (auth) async {
      final responseStorage = await storage.upload(
        FirebaseStorageTables.users,
        auth.user!.uid,
        File(input.photo),
      );

      return await responseStorage.fold((l) => throw l, (linkPhoto) async {
        print(linkPhoto);

        var map = {
          "id": auth.user!.uid,
          "name": input.name,
          "phone": input.phone,
          "cep": input.cep,
          "value": input.value,
          "isActive": true,
          "createdAt": DateTime.now().toUtc().millisecondsSinceEpoch,
          "typeUser": TypeUser.immobile.name,
          "typeImmobile": input.typeImmobile?.name,
          "photos": [linkPhoto],
        };

        print(map);
        await database.create(FirebaseDataTables.users, map);

        return UserModel.fromMap({
          "id": auth.user!.uid,
          "email": input.email,
          "password": input.password,
          "typeUser": TypeUser.immobile.name,
          "photo": linkPhoto,
        });
      });
    });
  }

  @override
  Future<UserModel> signupUser(SignupUserInput input) async {
    final response = await auth.createUser(input.email, input.password);
    return await response.fold((l) => throw l, (auth) async {
      final responseStorage = await storage.upload(
        FirebaseStorageTables.users,
        auth.user!.uid,
        File(input.photo),
      );

      return await responseStorage.fold((l) => throw l, (linkPhoto) async {
        print(linkPhoto);
        var map = {
          "id": auth.user!.uid,
          "name": input.name,
          "phone": input.phone,
          "isActive": true,
          "createdAt": DateTime.now().toUtc().millisecondsSinceEpoch,
          "typeUser": TypeUser.person.name,
          "skills": input.skills.map((e) => e.name).toList(),
          "photos": [linkPhoto],
        };

        print(map);

        await database.create(FirebaseDataTables.users, map);

        return UserModel.fromMap({
          "id": auth.user!.uid,
          "email": input.email,
          "password": input.password,
          "typeUser": TypeUser.person.name,
          "photo": linkPhoto,
        });
      });
    });
  }
}
