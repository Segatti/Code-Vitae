import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_immobile_input.dart';
import '../../domain/entities/inputs/signup_user_input.dart';
import '../../domain/states/auth_state.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/recover_password_user.dart';
import '../../domain/usecases/signup_immobile.dart';
import '../../domain/usecases/signup_user.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this.loginUser,
    this.signupUser,
    this.signupImmobile,
    this.recoverPasswordUser,
  ) : super(InitialState());

  final ILoginUser loginUser;
  final ISignupUser signupUser;
  final ISignupImmobile signupImmobile;
  final IRecoverPasswordUser recoverPasswordUser;

  Future<void> login(String email, String password) async {
    final response = await loginUser(
      LoginInput(email, password),
    );
    emit(response);
  }

  Future<void> recoverPassword(String email) async {
    final response = await recoverPasswordUser(email);
    emit(response);
  }

  Future<void> signup([
    SignupUserInput? inputUser,
    SignupImmobileInput? inputImmobile,
  ]) async {
    if (inputUser != null) {
      final response = await signupUser(inputUser);
      emit(response);
    } else if (inputImmobile != null) {
      final response = await signupImmobile(inputImmobile);
      emit(response);
    } else {
      emit(ErrorState("Specific", "Invalid params signup"));
    }
  }
}
