import 'package:aluga_comigo/app/modules/houses/ui/pages/houses_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HousesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child("/", child: (context) => const HousesPage());
  }
}
