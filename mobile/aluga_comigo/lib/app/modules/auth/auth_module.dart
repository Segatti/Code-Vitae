import 'package:flutter_modular/flutter_modular.dart';

import 'ui/auth_page.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {}

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
