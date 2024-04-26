import 'package:aluga_comigo/app/modules/auth/domain/usecases/recover_password_user.dart';
import 'package:aluga_comigo/app/modules/auth/infra/datasources/auth_datasource.dart';
import 'package:aluga_comigo/app/modules/auth/infra/repositories/auth_repository.dart';
import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:aluga_comigo/app/shared/data/services/camera_service.dart';
import 'package:aluga_comigo/app/shared/data/services/firebase_auth_service.dart';
import 'package:aluga_comigo/app/shared/data/services/secure_storage_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/data/services/firebase_database_service.dart';
import '../../shared/data/services/firebase_storage_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/signup_immobile.dart';
import 'domain/usecases/signup_user.dart';
import 'external/datasources/auth_firebase_datasource.dart';
import 'presenter/auth_page.dart';
import 'presenter/cubits/auth_cubit.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.addSingleton(FirebaseAuthService.new);
    i.addSingleton(FirebaseDatabaseService.new);
    i.addSingleton(FirebaseStorageService.new);
    i.addSingleton(SecureStorageService.new);
    i.addSingleton(CameraService.new);

    // Repositories
    i.addSingleton<IAuthRepository>(AuthRepository.new);

    // Datasources
    i.addSingleton<IAuthDatasource>(AuthFirebaseDatasource.new);

    // Use cases
    i.addLazySingleton<ILoginUser>(LoginUser.new);
    i.addLazySingleton<ISignupUser>(SignupUser.new);
    i.addLazySingleton<ISignupImmobile>(SignupImmobile.new);
    i.addLazySingleton<IRecoverPasswordUser>(RecoverPasswordUser.new);

    i.add(AuthCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => const AuthPage(),
      duration: const Duration(milliseconds: 500),
      transition: TransitionType.rightToLeft,
    );
  }
}
