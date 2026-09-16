import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
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
      child: (_, _) => const ChatsListPage(),
    );
    c.route(
      '/chat',
      transition: AppTransitions.rightToLeft,
      child: (_, state) {
        final args = state.arguments! as Map<String, dynamic>;
        return ChatPage(chat: args['chat'] as Chat);
      },
    );
  }
}
