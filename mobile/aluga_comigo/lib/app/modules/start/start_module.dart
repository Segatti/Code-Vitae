import 'package:aluga_comigo/app/modules/chats/chats_module.dart';
import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chat_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/pages/chat_page.dart';
import 'package:aluga_comigo/app/modules/customer/customer_module.dart';
import 'package:aluga_comigo/app/modules/house/houses_module.dart';
import 'package:aluga_comigo/app/modules/like/likes_module.dart';
import 'package:aluga_comigo/app/modules/my_immobiles/my_immobiles_module.dart';
import 'package:aluga_comigo/app/modules/start/ui/pages/start_page.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StartModule extends Module {
  @override
  String? get path => '/start';

  @override
  void register(ModularContext c) {
    c.route(
      '/chat',
      provide: (scoped) {
        scoped.addChangeNotifier<IChatController>(ChatController.new);
      },
      transition: AppTransitions.rightToLeft,
      child: (_, state) {
        final args = state.arguments! as Map<String, dynamic>;
        return ChatPage(chat: args['chat'] as Chat);
      },
    );
    c.route(
      '/',
      child: (_, _) => const StartPage(),
      children: (c) {
        c.module(CustomerModule(), at: '/customers');
        c.module(HousesModule(), at: '/houses');
        c.module(MyImmobilesModule(), at: '/my-immobiles');
        c.module(LikesModule(), at: '/likes');
        c.module(ChatsModule(), at: '/chats');
      },
    );
  }
}
