import 'package:aluga_comigo/app/modules/auth/domain/entities/user.dart';
import 'package:aluga_comigo/app/shared/domain/entities/failures.dart';
import 'package:aluga_comigo/app/shared/domain/typedefs/returns.dart';
import 'package:dartz/dartz.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/data/services/session_service.dart';
import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_input.dart';
import '../../domain/repositories/auth_repository.dart';
import '../interfaces/auth_datasource.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDatasource datasource;

  const AuthRepository(this.datasource);

  @override
  Future<Return<User>> login(LoginInput input) async {
    try {
      final response = await datasource.login(input);
      SessionService.setCustomer(response);
      return Right(User(
        id: response.id,
        email: response.email,
        password: response.password,
        typeUser: response.typeUser,
        photo: response.photos[0],
        lastMatch: response.lastMatch,
      ));
    } catch (e, s) {
      debugPrint(s.toString());
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(
          FailureRepository(message: e.toString()),
        );
      }
    }
  }

  @override
  Future<Return<bool>> recoverPassword(String input) async {
    try {
      final response = await datasource.recoverPassword(input);
      return Right(response);
    } catch (e, s) {
      debugPrint(s.toString());
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(
          FailureRepository(message: e.toString()),
        );
      }
    }
  }

  @override
  Future<Return<User>> signupImmobile(SignupImmobileInput input) async {
    try {
      final response = await datasource.signupImmobile(input);
      SessionService.setCustomer(response);
      return Right(User(
        id: response.id,
        email: response.email,
        password: response.password,
        typeUser: response.typeUser,
        photo: response.photos[0],
        lastMatch: response.lastMatch,
      ));
    } catch (e, s) {
      debugPrint(s.toString());
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(
          FailureRepository(message: e.toString()),
        );
      }
    }
  }

  @override
  Future<Return<User>> signupUser(SignupUserInput input) async {
    try {
      final response = await datasource.signupUser(input);
      SessionService.setCustomer(response);
      return Right(User(
        id: response.id,
        email: response.email,
        password: response.password,
        typeUser: response.typeUser,
        photo: response.photos[0],
        lastMatch: response.lastMatch,
      ));
    } catch (e, s) {
      debugPrint(s.toString());
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(
          FailureRepository(message: e.toString()),
        );
      }
    }
  }
}
