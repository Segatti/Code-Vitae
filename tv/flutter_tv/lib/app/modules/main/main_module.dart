import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/pages/main_page.dart';
import 'presenter/stores/main_store.dart';

class MainModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<MainStore>((i) => MainStore()),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const MainPage(),
          transition: TransitionType.rightToLeft,
        ),
      ];
}
