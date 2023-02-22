import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/navigation/presenter/pages/splash_page.dart';
import 'package:flutter_tv/app/modules/navigation/presenter/stores/splash_store.dart';

import 'modules/auth/auth_module.dart';
import 'modules/main/main_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.factory<SplashStore>((i) => SplashStore()),
  ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const SplashPage()),
        ModuleRoute('/auth', module: AuthModule()),
        ModuleRoute('/main', module: MainModule()),
      ];
}
