import 'package:aluga_comigo/app/modules/quest/ui/pages/quests_page.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuestModule extends Module {
  @override
  String? get path => '/quest';

  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.rightToLeft,
      child: (_, __) => const QuestsPage(),
    );
  }
}
