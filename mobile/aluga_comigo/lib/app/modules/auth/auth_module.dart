import 'package:aluga_comigo/app/modules/auth/auth_di_module.dart';
import 'package:aluga_comigo/app/modules/auth/presenter/auth_page.dart';
import 'package:aluga_comigo/app/modules/auth/presenter/controllers/auth_controller.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  String? get path => '/auth';

  @override
  void register(ModularContext c) {
    c.module(AuthDiModule());
    c.add<IAuthController>(AuthController.new);
    c.route(
      '/',
      transition: AppTransitions.rightToLeft,
      child: (_, __) => const AuthPage(),
    );
  }
}
