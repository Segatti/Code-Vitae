import 'package:flutter_modular/flutter_modular.dart';

import 'ui/intro_page.dart';
import 'ui/splash_page.dart';

class IntroModule extends Module {
  @override
  void binds(Injector i) {}

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
