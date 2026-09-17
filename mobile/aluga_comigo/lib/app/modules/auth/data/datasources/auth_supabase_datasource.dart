import 'dart:io';

import '../../../../shared/data/services/supabase_auth_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/data/services/supabase_storage_service.dart';
import '../../../../shared/domain/entities/failures.dart';
import '../../../../shared/domain/typedefs/returns.dart';
import '../../../../shared/domain/helpers/image_helper.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_input.dart';
import '../../domain/enums/type_user.dart';
import '../interfaces/auth_datasource.dart';

class AuthSupabaseDatasource implements IAuthDatasource {
  final SupabaseAuthService auth;
  final SupabaseDatabaseService database;
  final SupabaseStorageService storage;

  const AuthSupabaseDatasource(this.auth, this.database, this.storage);

  Future<CustomerModel> _readCustomerByUid(String uid) async {
    final profile = await database.readProfile(uid);
    return profile.fold(
      (failure) => throw failure,
      (Json map) {
        if (map.isEmpty) {
          throw FailureDatasource(message: 'Perfil não encontrado');
        }
        return CustomerModel.fromMap(map);
      },
    );
  }

  @override
  Future<CustomerModel> login(LoginInput input) async {
    final response = await auth.login(input.email, input.password);
    return await response.fold((l) => throw l, (r) async {
      final uid = r.user?.id;
      if (uid == null) {
        throw FailureDatasource(message: 'Usuário não autenticado');
      }

      final customer = await _readCustomerByUid(uid);
      return switch (customer) {
        PersonCustomerModel() => customer
            .copyWith(email: input.email)
            .copyWith(password: input.password),
        ImmobileCustomerModel() => customer
            .copyWith(email: input.email)
            .copyWith(password: input.password),
      };
    });
  }

  @override
  Future<bool> recoverPassword(String input) async {
    final response = await auth.recoverPassword(input);
    return await response.fold((l) => throw l, (r) => r);
  }

  Future<File> _preparePhotoFile(String photoPath) async {
    if (photoPath.isEmpty) {
      throw FailureDatasource(
        message: 'Adicione uma foto antes de concluir o cadastro.',
      );
    }

    final photoFile = File(photoPath);
    if (!await photoFile.exists()) {
      throw FailureDatasource(
        message: 'Foto não encontrada. Tire ou selecione novamente.',
      );
    }

    return await ImageHelper.compressForUpload(photoFile) ?? photoFile;
  }

  Future<({String uid, String linkPhoto})> _signupAuthAndUpload(
    String email,
    String password,
    File file,
  ) async {
    var authCreated = false;

    try {
      final response = await auth.createUser(email, password);
      final authResponse = response.fold((l) => throw l, (r) => r);
      final uid = authResponse.user?.id;

      if (uid == null) {
        throw FailureDatasource(
          message: 'Confirme seu e-mail ou tente novamente.',
        );
      }

      authCreated = true;

      final storageResult = await storage.upload(
        StorageBuckets.avatars,
        '$uid/profile.jpg',
        file,
      );

      final linkPhoto = storageResult.fold((l) => throw l, (r) => r);
      return (uid: uid, linkPhoto: linkPhoto);
    } catch (e) {
      if (authCreated) {
        await auth.deleteCurrentUser();
      }
      rethrow;
    }
  }

  @override
  Future<CustomerModel> signupImmobile(SignupImmobileInput input) async {
    final file = await _preparePhotoFile(input.photo);
    final signupData = await _signupAuthAndUpload(
      input.email,
      input.password,
      file,
    );

    try {
      final appMap = {
        'id': signupData.uid,
        'ownerAccountId': signupData.uid,
        'email': input.email,
        'typeUser': TypeUser.immobile.name,
        'phone': input.phone,
        'cep': input.cep,
        'price': input.value,
        'state': input.state,
        'city': input.city,
        'typeImmobile': input.typeImmobile?.name ?? 'none',
        'name': input.name,
        'shortDescription': '',
        'photos': [signupData.linkPhoto],
        'isActive': true,
      };

      final result = await database.createProfile(appMap);
      result.fold((failure) => throw failure, (_) {});

      final immobile = ImmobileCustomerModel.fromMap(appMap);
      return immobile
          .copyWith(email: input.email)
          .copyWith(password: input.password);
    } catch (e) {
      await auth.deleteCurrentUser();
      rethrow;
    }
  }

  @override
  Future<CustomerModel> signupUser(SignupUserInput input) async {
    final file = await _preparePhotoFile(input.photo);
    final signupData = await _signupAuthAndUpload(
      input.email,
      input.password,
      file,
    );

    try {
      final appMap = {
        'id': signupData.uid,
        'email': input.email,
        'typeUser': TypeUser.person.name,
        'name': input.name,
        'phone': input.phone,
        'state': input.state,
        'city': input.city,
        'skills': input.skills.map((e) => e.name).toList(),
        'photos': [signupData.linkPhoto],
        'isActive': true,
      };

      final result = await database.createProfile(appMap);
      result.fold((failure) => throw failure, (_) {});

      final person = PersonCustomerModel.fromMap(appMap);
      return person
          .copyWith(email: input.email)
          .copyWith(password: input.password);
    } catch (e) {
      await auth.deleteCurrentUser();
      rethrow;
    }
  }
}
