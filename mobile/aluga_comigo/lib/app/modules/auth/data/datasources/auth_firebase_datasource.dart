import 'dart:io';

import '../../../../shared/data/services/firebase_auth_service.dart';
import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../../shared/data/services/firebase_storage_service.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_input.dart';
import '../../domain/enums/type_user.dart';
import '../interfaces/auth_datasource.dart';

class AuthFirebaseDatasource implements IAuthDatasource {
  final FirebaseAuthService auth;
  final FirebaseDatabaseService database;
  final FirebaseStorageService storage;

  const AuthFirebaseDatasource(this.auth, this.database, this.storage);

  @override
  Future<CustomerModel> login(LoginInput input) async {
    final response = await auth.login(input.email, input.password);
    return await response.fold((l) => throw l, (r) async {
      final data = await database.read(FirebaseDataTables.users, r.user!.uid);
      return await data.fold((l) => throw l, (r2) async {
        final data = r2;

        return CustomerModel.fromMap(
          data,
        ).copyWith(email: input.email).copyWith(password: input.password);
      });
    });
  }

  @override
  Future<bool> recoverPassword(String input) async {
    final response = await auth.recoverPassword(input);
    return await response.fold((l) => throw l, (r) => r);
  }

  @override
  Future<CustomerModel> signupImmobile(SignupImmobileInput input) async {
    final response = await auth.createUser(input.email, input.password);
    return await response.fold((l) => throw l, (auth) async {
      final responseStorage = await storage.upload(
        FirebaseStorageTables.users,
        auth.user!.uid,
        File(input.photo),
      );

      return await responseStorage.fold((l) => throw l, (linkPhoto) async {
        var map = {
          "id": auth.user!.uid,
          "name": input.name,
          "phone": input.phone,
          "cep": input.cep,
          "value": input.value,
          "state": input.state,
          "city": input.city,
          "email": input.email,
          "password": input.password,
          "isActive": true,
          "createdAt": DateTime.now().toUtc().millisecondsSinceEpoch,
          "typeUser": TypeUser.immobile.name,
          "typeImmobile": input.typeImmobile?.name,
          "photos": [linkPhoto],
        };

        await database.create(FirebaseDataTables.users, map);

        return CustomerModel.fromMap(
          map,
        ).copyWith(email: input.email).copyWith(password: input.password);
      });
    });
  }

  @override
  Future<CustomerModel> signupUser(SignupUserInput input) async {
    final response = await auth.createUser(input.email, input.password);
    return await response.fold((l) => throw l, (auth) async {
      final responseStorage = await storage.upload(
        FirebaseStorageTables.users,
        auth.user!.uid,
        File(input.photo),
      );

      return await responseStorage.fold((l) => throw l, (linkPhoto) async {
        var map = {
          "id": auth.user!.uid,
          "name": input.name,
          "phone": input.phone,
          "state": input.state,
          "city": input.city,
          "isActive": true,
          "email": input.email,
          "password": input.password,
          "createdAt": DateTime.now().toUtc().millisecondsSinceEpoch,
          "typeUser": TypeUser.person.name,
          "skills": input.skills.map((e) => e.name).toList(),
          "photos": [linkPhoto],
        };

        await database.create(FirebaseDataTables.users, map);

        return CustomerModel.fromMap(
          map,
        ).copyWith(email: input.email).copyWith(password: input.password);
      });
    });
  }
}
