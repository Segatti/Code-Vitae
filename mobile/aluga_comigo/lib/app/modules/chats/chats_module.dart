import 'package:aluga_comigo/app/modules/chats/ui/pages/chats_list_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatsModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => const ChatsListPage(),
      transition: TransitionType.upToDown,
    );
  }
}
