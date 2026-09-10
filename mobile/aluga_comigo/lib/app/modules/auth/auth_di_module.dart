import 'package:aluga_comigo/app/modules/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:aluga_comigo/app/modules/auth/data/interfaces/auth_datasource.dart';
import 'package:aluga_comigo/app/modules/auth/data/repositories/auth_repository.dart';
import 'package:aluga_comigo/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:aluga_comigo/app/modules/auth/domain/usecases/login_user.dart';
import 'package:aluga_comigo/app/modules/auth/domain/usecases/recover_password_user.dart';
import 'package:aluga_comigo/app/modules/auth/domain/usecases/signup_immobile.dart';
import 'package:aluga_comigo/app/modules/auth/domain/usecases/signup_user.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IAuthRepository>(AuthRepository.new);
    c.addSingleton<IAuthDatasource>(AuthFirebaseDatasource.new);
    c.addLazySingleton<ILoginUser>(LoginUser.new);
    c.addLazySingleton<ISignupUser>(SignupUser.new);
    c.addLazySingleton<ISignupImmobile>(SignupImmobile.new);
    c.addLazySingleton<IRecoverPasswordUser>(RecoverPasswordUser.new);
  }
}
