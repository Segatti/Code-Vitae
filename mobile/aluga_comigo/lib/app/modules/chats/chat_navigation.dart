import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

import 'domain/entities/chat.dart';

abstract final class ChatNavigation {
  static const routePath = '/start/chat';

  static Future<void> open(BuildContext context, Chat chat) {
    return context.pushNamed(
      routePath,
      arguments: {'chat': chat},
    );
  }
}
