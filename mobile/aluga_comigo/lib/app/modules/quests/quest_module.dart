import 'package:aluga_comigo/app/modules/quests/ui/pages/quests_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuestModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => const QuestsPage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
