import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:aluga_comigo/app/shared/data/services/firebase_auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/auth_page.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(Injector i) {
    i.addSingleton(FirebaseAuthService.new);
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
