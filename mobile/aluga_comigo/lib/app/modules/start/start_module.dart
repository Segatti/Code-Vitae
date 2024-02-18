import 'package:aluga_comigo/app/modules/start/ui/pages/start_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StartModule extends Module {
  @override
  void binds(Injector i) {
    // TODO: implement binds
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => const StartPage(),
      children: [
        // ModuleRoute("/customers", module: module),
      ],
    );
  }
}
