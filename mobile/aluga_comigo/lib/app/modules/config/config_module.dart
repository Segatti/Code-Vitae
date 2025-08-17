import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/profile_datasource.dart';
import 'data/repositories/profile_repository.dart';
import 'domain/usecases/get_profile.dart';
import 'domain/usecases/update_profile.dart';
import 'ui/controllers/profile_controller.dart';
import 'ui/pages/profile_page.dart';
import 'ui/pages/security_page.dart';

class ConfigModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<IProfileDatasource>(ProfileDatasource.new);
    i.addSingleton<IProfileRepository>(ProfileRepository.new);
    i.addLazySingleton<IGetProfile>(GetProfile.new);
    i.addLazySingleton<IUpdateProfile>(UpdateProfile.new);
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
      child: (_) => const ProfilePage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
