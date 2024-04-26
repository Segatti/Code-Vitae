import 'package:equatable/equatable.dart';

import '../entities/user.dart';

abstract class AuthState extends Equatable {}

class InitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

abstract class SuccessState extends AuthState {
  SuccessState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class LoginSuccessState extends SuccessState {
  LoginSuccessState(super.user);
}

class SignupSuccessState extends SuccessState {
  SignupSuccessState(super.user);
}

class RecoverSuccessState extends AuthState {
  RecoverSuccessState();

  @override
  List<Object?> get props => [];
}

class ErrorState extends AuthState {
  ErrorState(this.code, this.message);

  final String code;
  final String message;

  @override
  List<Object> get props => [code, message];
}
