import 'package:flutter_modular/flutter_modular.dart';

import 'login_page.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => const LoginPage(),
      duration: const Duration(milliseconds: 500),
      transition: TransitionType.rightToLeft,
    );
  }
}
