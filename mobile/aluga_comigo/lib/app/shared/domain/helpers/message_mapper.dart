import '../typedefs/json.dart';

class MessageMapper {
  static Json fromRow(Json row, String currentUserId) {
    return {
      'id': row['id']?.toString() ?? '',
      'chatId': row['chat_id']?.toString() ?? '',
      'senderId': row['sender_id']?.toString() ?? '',
      'isFromUser': row['sender_id']?.toString() == currentUserId,
      'content': row['content'] ?? '',
      'messageType': row['message_type'] ?? 'text',
      'createdAt': row['created_at'],
      'readAt': row['read_at'],
    };
  }

  static Json toRow({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
  }) {
    return {
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
    };
  }
}
