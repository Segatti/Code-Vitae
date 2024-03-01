import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/likes_page.dart';

class LikesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => const LikesPage(),
      transition: TransitionType.upToDown,
    );
  }
}
