import 'package:aluga_comigo/app/modules/auth/domain/entities/inputs/signup_input.dart';
import 'package:aluga_comigo/app/shared/data/services/analytics_service.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/analytics/analytics_events.dart';
import 'package:material_ui/material_ui.dart';

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
  final IAnalyticsService _analytics;

  AuthController(
    this._loginUser,
    this._signupUser,
    this._signupImmobile,
    this._recoverPasswordUser,
    this._analytics,
  );

  Future<void> _trackAuthSuccess({required String eventName}) async {
    final userId = SessionService.customer?.id;
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(
      name: AnalyticsParams.userType,
      value: SessionService.customer?.typeUser.name,
    );
    await _analytics.logEvent(
      eventName,
      parameters: {AnalyticsParams.method: 'email'},
    );
  }

  @override
  Future<bool> login(LoginInput input) async {
    final response = await _loginUser(
      LoginInput(input.email, input.password),
    );

    return response.fold(
      (error) async {
        errorMessage = "${error.origin} - ${error.message}";
        return false;
      },
      (result) async {
        await _trackAuthSuccess(eventName: AnalyticsEvents.login);
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
          (error) async {
            errorMessage = "${error.origin} - ${error.message}";
            return false;
          },
          (result) async {
            await _trackAuthSuccess(eventName: AnalyticsEvents.signUp);
            return true;
          },
        );
      case SignupUserInput():
        final response = await _signupUser(input);
        return response.fold(
          (error) async {
            errorMessage = "${error.origin} - ${error.message}";
            return false;
          },
          (result) async {
            await _trackAuthSuccess(eventName: AnalyticsEvents.signUp);
            return true;
          },
        );
    }
  }
}
