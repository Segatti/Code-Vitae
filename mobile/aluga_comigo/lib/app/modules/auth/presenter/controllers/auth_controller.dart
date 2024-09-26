import 'package:aluga_comigo/app/modules/auth/domain/entities/inputs/signup_input.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/inputs/login_input.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/recover_password_user.dart';
import '../../domain/usecases/signup_immobile.dart';
import '../../domain/usecases/signup_user.dart';

abstract class IAuthController extends ChangeNotifier {
  String errorMessage = "";

  Future<bool> login(LoginInput input);
  Future<bool> signup(SignupInput input);
  Future<bool> recoverPassword(String email);
}

class AuthController extends IAuthController {
  final ILoginUser _loginUser;
  final ISignupUser _signupUser;
  final ISignupImmobile _signupImmobile;
  final IRecoverPasswordUser _recoverPasswordUser;

  AuthController(
    this._loginUser,
    this._signupUser,
    this._signupImmobile,
    this._recoverPasswordUser,
  );

  @override
  Future<bool> login(LoginInput input) async {
    final response = await _loginUser(
      LoginInput(input.email, input.password),
    );

    return response.fold(
      (error) {
        errorMessage = "${error.origin} - ${error.message}";
        return false;
      },
      (result) {
        return true;
      },
    );
  }

  @override
  Future<bool> recoverPassword(String email) async {
    final response = await _recoverPasswordUser(email);
    return response.fold(
      (error) {
        errorMessage = "${error.origin} - ${error.message}";
        return false;
      },
      (result) {
        return true;
      },
    );
  }

  @override
  Future<bool> signup(SignupInput input) async {
    switch (input) {
      case SignupImmobileInput():
        final response = await _signupImmobile(input);
        return response.fold(
          (error) {
            errorMessage = "${error.origin} - ${error.message}";
            return false;
          },
          (result) {
            return true;
          },
        );
      case SignupUserInput():
        final response = await _signupUser(input);
        return response.fold(
          (error) {
            errorMessage = "${error.origin} - ${error.message}";
            return false;
          },
          (result) {
            return true;
          },
        );
    }
  }
}
