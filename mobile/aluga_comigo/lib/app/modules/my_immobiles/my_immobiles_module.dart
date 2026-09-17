import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/my_immobiles_list_page.dart';

class MyImmobilesModule extends Module {
  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.upToDown,
      child: (_, _) => const MyImmobilesListPage(),
    );
  }
}
