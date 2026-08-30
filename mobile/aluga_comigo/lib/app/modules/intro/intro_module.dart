import 'package:aluga_comigo/app/modules/auth/auth_di_module.dart';
import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/intro_page.dart';
import 'ui/splash_page.dart';

class IntroModule extends Module {
  @override
  String? get path => '/';

  @override
  void register(ModularContext c) {
    c.module(CoreModule());
    c.module(AuthDiModule());
    c.route('/', child: (_, _) => const SplashPage());
    c.route(
      '/intro',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const IntroPage(),
    );
  }
}
