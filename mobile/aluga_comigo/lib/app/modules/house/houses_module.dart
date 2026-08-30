import 'package:aluga_comigo/app/modules/customer/customer_di_module.dart';
import 'package:aluga_comigo/app/modules/house/ui/controllers/houses_controller.dart';
import 'package:aluga_comigo/app/modules/house/ui/pages/houses_page.dart';
import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HousesModule extends Module {
  @override
  void register(ModularContext c) {
    c.module(CoreModule());
    c.module(CustomerDiModule());
    c.add<IHousesController>(HousesController.new);
    c.route(
      '/',
      transition: AppTransitions.upToDown,
      child: (_, _) => const HousesPage(),
    );
  }
}
