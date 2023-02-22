import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/auth/presenter/stores/login_store.dart';

import 'presenter/pages/login_page.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.factory<LoginStore>((i) => LoginStore()),
  ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const LoginPage()),
      ];
}
