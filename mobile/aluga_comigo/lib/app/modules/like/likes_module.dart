import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/history_likes_page.dart';
import 'ui/pages/likes_page.dart';

class LikesModule extends Module {
  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.upToDown,
      child: (_, __) => const LikesPage(),
    );
    c.route(
      '/history',
      transition: AppTransitions.rightToLeft,
      child: (_, __) => const HistoryLikesPage(),
    );
  }
}
