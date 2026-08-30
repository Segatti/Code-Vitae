import 'package:aluga_comigo/app/modules/chats/interactor/models/contact.dart';
import 'package:aluga_comigo/app/modules/chats/ui/pages/chat_page.dart';
import 'package:aluga_comigo/app/modules/chats/ui/pages/chats_list_page.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatsModule extends Module {
  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.upToDown,
      child: (_, __) => const ChatsListPage(),
    );
    c.route(
      '/chat',
      transition: AppTransitions.rightToLeft,
      child: (_, state) {
        final args = state.arguments! as Map<String, dynamic>;
        return ChatPage(
          idChat: args['idChat'] as String,
          contact: args['contact'] as Contact,
        );
      },
    );
  }
}
