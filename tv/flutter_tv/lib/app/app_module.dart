import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/navigation/presenter/pages/splash_page.dart';
import 'package:flutter_tv/app/modules/navigation/presenter/stores/splash_store.dart';

import 'modules/auth/auth_module.dart';
import 'modules/main/main_module.dart';

class AppModule extends Module {
  @override
  void register(ModularContext c) {
    c.add<SplashStore>(() => SplashStore());
    c.route('/', child: (context, state) => const SplashPage());
    c.module(AuthModule());
    c.module(MainModule());
  }
}
