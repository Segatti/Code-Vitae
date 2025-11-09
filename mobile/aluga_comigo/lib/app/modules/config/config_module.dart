import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:aluga_comigo/app/shared/data/services/camera_service.dart';
import 'package:aluga_comigo/app/shared/data/services/firebase_storage_service.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../auth/domain/enums/type_user.dart';
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
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    // Services
    i.addSingleton<CameraService>(CameraService.new);
    i.addSingleton<FirebaseStorageService>(FirebaseStorageService.new);

    // Datasource
    i.addSingleton<IProfileDatasource>(ProfileDatasource.new);

    // Repository
    i.addSingleton<IProfileRepository>(ProfileRepository.new);

    // Use cases
    i.addLazySingleton<IGetProfile>(GetProfile.new);
    i.addLazySingleton<IUpdateProfile>(UpdateProfile.new);

    // Controller
    i.add<IProfileController>(ProfileController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/security",
      child: (_) => const SecurityPage(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      "/profile",
      child: (_) => SessionService.customer!.typeUser == TypeUser.person
          ? ProfileUserPage()
          : ProfileImmobilePage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
