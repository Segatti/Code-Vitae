import 'package:aluga_comigo/app/modules/customers/customers_module.dart';
import 'package:aluga_comigo/app/modules/houses/houses_module.dart';
import 'package:aluga_comigo/app/modules/start/ui/pages/start_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StartModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => const StartPage(),
      children: [
        ModuleRoute("/customers", module: CustomersModule()),
        ModuleRoute("/houses", module: HousesModule()),
      ],
    );
  }
}
