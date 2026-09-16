import 'package:aluga_comigo/app/modules/like/ui/controllers/history_controller.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/history_likes_page.dart';

class HistoryModule extends Module {
  @override
  String? get path => '/history';

  @override
  void register(ModularContext c) {
    c.add<IHistoryController>(HistoryController.new);
    c.route(
      '/',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const HistoryLikesPage(),
    );
  }
}
