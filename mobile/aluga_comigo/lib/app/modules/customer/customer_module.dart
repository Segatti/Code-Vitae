import 'package:aluga_comigo/app/modules/customer/presenter/controllers/customers_controller.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/pages/customers_page.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomerModule extends Module {
  @override
  void register(ModularContext c) {
    c.add<ICustomersController>(CustomersController.new);
    c.route(
      '/',
      transition: AppTransitions.upToDown,
      child: (_, _) => const CustomersPage(),
    );
  }
}
