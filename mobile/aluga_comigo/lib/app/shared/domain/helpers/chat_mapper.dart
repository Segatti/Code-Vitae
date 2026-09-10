import '../typedefs/json.dart';

class ChatMapper {
  static Json fromRow(Json row, String currentUserId) {
    final isPerson = row['person_id']?.toString() == currentUserId;
    return {
      'id': row['id']?.toString() ?? '',
      'personId': row['person_id']?.toString() ?? '',
      'immobileId': row['immobile_id']?.toString() ?? '',
      'otherName': isPerson ? row['immobile_name'] : row['person_name'],
      'otherPhoto': isPerson ? row['immobile_photo'] : row['person_photo'],
      'lastMessagePreview': row['last_message_preview'] ?? '',
      'lastMessageAt': row['last_message_at'],
      'lastMessageSenderId': row['last_message_sender_id']?.toString() ?? '',
    };
  }
}
