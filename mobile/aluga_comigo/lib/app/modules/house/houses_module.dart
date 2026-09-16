import 'package:aluga_comigo/app/modules/house/ui/pages/houses_page.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HousesModule extends Module {
  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.upToDown,
      child: (_, _) => const HousesPage(),
    );
  }
}
