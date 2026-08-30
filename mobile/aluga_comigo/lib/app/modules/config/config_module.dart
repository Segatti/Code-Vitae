import 'package:aluga_comigo/app/modules/auth/domain/enums/type_user.dart';
import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:aluga_comigo/app/shared/data/services/camera_service.dart';
import 'package:aluga_comigo/app/shared/data/services/firebase_storage_service.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/profile_datasource.dart';
import 'data/repositories/profile_repository.dart';
import 'domain/usecases/get_profile.dart';
import 'domain/usecases/update_profile.dart';
import 'ui/controllers/profile_controller.dart';
import 'ui/pages/profile_immobile_page.dart';
import 'ui/pages/profile_user_page.dart';
import 'ui/pages/security_page.dart';

class ConfigModule extends Module {
  @override
  String? get path => '/config';

  @override
  void register(ModularContext c) {
    c.module(CoreModule());
    c.addSingleton<CameraService>(CameraService.new);
    c.addSingleton<FirebaseStorageService>(FirebaseStorageService.new);
    c.addSingleton<IProfileDatasource>(ProfileDatasource.new);
    c.addSingleton<IProfileRepository>(ProfileRepository.new);
    c.addLazySingleton<IGetProfile>(GetProfile.new);
    c.addLazySingleton<IUpdateProfile>(UpdateProfile.new);
    c.add<IProfileController>(ProfileController.new);
    c.route(
      '/security',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const SecurityPage(),
    );
    c.route(
      '/profile',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => SessionService.customer!.typeUser == TypeUser.person
          ? ProfileUserPage()
          : ProfileImmobilePage(),
    );
  }
}
