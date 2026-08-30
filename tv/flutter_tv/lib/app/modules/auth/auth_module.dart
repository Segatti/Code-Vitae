import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/auth/presenter/stores/recover_password_store.dart';

import 'presenter/pages/login_page.dart';
import 'presenter/pages/recover_password_page.dart';
import 'presenter/pages/sign_page.dart';
import 'presenter/stores/login_store.dart';
import 'presenter/stores/sign_store.dart';

class AuthModule extends Module {
  @override
  String? get path => '/auth';

  @override
  void register(ModularContext c) {
    c.add<LoginStore>(() => LoginStore());
    c.add<SignStore>(() => SignStore());
    c.add<RecoverPasswordStore>(() => RecoverPasswordStore());
    c.route(
      '/',
      child: (context, state) => const LoginPage(),
      transition: TransitionType.fade,
    );
    c.route(
      '/sign',
      child: (context, state) => const SignPage(),
      transition: TransitionType.fade,
    );
    c.route(
      '/recover',
      child: (context, state) => const RecoverPasswordPage(),
      transition: TransitionType.fade,
    );
  }
}
