import 'package:aluga_comigo/app/modules/customers/ui/pages/customers_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomersModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child("/", child: (context) => const CustomersPage());
  }
}
