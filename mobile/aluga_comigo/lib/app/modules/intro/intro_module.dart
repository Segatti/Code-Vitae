import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/core_module.dart';
import '../../shared/data/services/secure_storage_service.dart';
import 'ui/intro_page.dart';
import 'ui/splash_page.dart';

class IntroModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.addSingleton<SecureStorageService>(SecureStorageService.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const SplashPage());
    r.child(
      '/intro',
      child: (context) => const IntroPage(),
      duration: const Duration(milliseconds: 500),
      transition: TransitionType.rightToLeft,
    );
  }
}
