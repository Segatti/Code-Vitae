import 'dart:convert';

abstract final class ChatNotificationPayload {
  static const _typeChatMessage = 'chatMessage';

  static String encodeChatMessage({required String chatId}) {
    return jsonEncode({
      'type': _typeChatMessage,
      'chatId': chatId,
    });
  }

  static String? extractChatId(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      if (map['type']?.toString() != _typeChatMessage) return null;
      final chatId = map['chatId']?.toString() ?? '';
      return chatId.isEmpty ? null : chatId;
    } catch (_) {
      return null;
    }
  }
}
