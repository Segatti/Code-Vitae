import 'package:aluga_comigo/app/modules/auth/domain/entities/user.dart';
import 'package:aluga_comigo/app/shared/domain/entities/failures.dart';
import 'package:aluga_comigo/app/shared/domain/typedefs/returns.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

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
      return Right(User.fromModel(response));
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
      return Right(User.fromModel(response));
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
      return Right(User.fromModel(response));
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
