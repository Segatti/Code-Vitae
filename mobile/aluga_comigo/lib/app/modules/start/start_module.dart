import 'package:aluga_comigo/app/modules/chats/chats_module.dart';
import 'package:aluga_comigo/app/modules/customer/customer_module.dart';
import 'package:aluga_comigo/app/modules/house/houses_module.dart';
import 'package:aluga_comigo/app/modules/like/likes_module.dart';
import 'package:aluga_comigo/app/modules/start/ui/pages/start_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StartModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => const StartPage(),
      children: [
        ModuleRoute("/customers", module: CustomerModule()),
        ModuleRoute("/houses", module: HousesModule()),
        ModuleRoute("/likes", module: LikesModule()),
        ModuleRoute("/chats", module: ChatsModule()),
      ],
    );
  }
}
