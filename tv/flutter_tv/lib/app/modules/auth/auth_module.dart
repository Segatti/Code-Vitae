import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/auth/presenter/stores/recover_password_store.dart';

import 'presenter/pages/login_page.dart';
import 'presenter/pages/recover_password_page.dart';
import 'presenter/pages/sign_page.dart';
import 'presenter/stores/login_store.dart';
import 'presenter/stores/sign_store.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<LoginStore>((i) => LoginStore()),
        Bind.factory<SignStore>((i) => SignStore()),
        Bind.factory<RecoverPasswordStore>((i) => RecoverPasswordStore()),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const LoginPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/sign',
          child: (context, args) => const SignPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/recover',
          child: (context, args) => const RecoverPasswordPage(),
          transition: TransitionType.fadeIn,
        ),
      ];
}
