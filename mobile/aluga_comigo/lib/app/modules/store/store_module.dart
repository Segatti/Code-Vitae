import 'package:aluga_comigo/app/modules/store/ui/pages/store_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StoreModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => const StorePage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
