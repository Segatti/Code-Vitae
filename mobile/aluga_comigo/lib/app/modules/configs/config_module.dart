import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/profile_page.dart';
import 'ui/pages/security_page.dart';

class ConfigModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/security",
      child: (_) => const SecurityPage(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      "/profile",
      child: (_) => const ProfilePage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
