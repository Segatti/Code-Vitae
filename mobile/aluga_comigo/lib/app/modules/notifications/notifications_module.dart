import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/notifications_page.dart';

class NotificationsModule extends Module {
  @override
  String? get path => '/notifications';

  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const NotificationsPage(),
    );
  }
}
