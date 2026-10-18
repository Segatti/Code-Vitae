import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

import '../../shared/navigation/modular_navigator.dart';
import 'domain/entities/chat.dart';
import 'domain/usecases/get_chat_by_id.dart';

abstract final class ChatNavigation {
  static const routePath = '/start/chat';

  static Future<void> open(BuildContext context, Chat chat) {
    return context.pushNamed(
      routePath,
      arguments: {'chat': chat},
    );
  }

  static Future<void> openById(String chatId) async {
    if (chatId.isEmpty) return;
    final context = ModularNavigator.context;
    if (context == null) return;

    final getChat = inject<IGetChatById>();
    final result = await getChat(chatId);
    result.fold(
      (_) {},
      (chat) => context.pushNamed(
        routePath,
        arguments: {'chat': chat},
      ),
    );
  }
}
