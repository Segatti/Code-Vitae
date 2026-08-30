import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

import 'presenter/pages/main_page.dart';
import 'presenter/stores/main_store.dart';

class MainModule extends Module {
  @override
  String? get path => '/main';

  @override
  void register(ModularContext c) {
    c.add<MainStore>(() => MainStore());
    c.route(
      '/',
      child: (context, state) => const MainPage(),
      transition: CustomTransition(
        transitionsBuilder: (context, animation, secondary, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1, 0), end: Offset.zero),
          ),
          child: child,
        ),
      ),
    );
  }
}
