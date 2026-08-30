import 'package:aluga_comigo/app/modules/chats/chats_module.dart';
import 'package:aluga_comigo/app/modules/customer/customer_module.dart';
import 'package:aluga_comigo/app/modules/house/houses_module.dart';
import 'package:aluga_comigo/app/modules/like/likes_module.dart';
import 'package:aluga_comigo/app/modules/start/ui/pages/start_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StartModule extends Module {
  @override
  String? get path => '/start';

  @override
  void register(ModularContext c) {
    c.route(
      '/',
      child: (_, __) => const StartPage(),
      children: (c) {
        c.module(CustomerModule(), at: '/customers');
        c.module(HousesModule(), at: '/houses');
        c.module(LikesModule(), at: '/likes');
        c.module(ChatsModule(), at: '/chats');
      },
    );
  }
}
