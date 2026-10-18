import 'chat_participant_helper.dart';
import '../typedefs/json.dart';

class ChatMapper {
  static Json fromRow(Json row, String currentUserId) {
    final display = ChatParticipantHelper.personImmobileDisplayFromRow(
      row,
      currentUserId,
    );

    return {
      'id': row['id']?.toString() ?? '',
      'personId': row['person_id']?.toString() ?? '',
      'immobileId': row['immobile_id']?.toString() ?? '',
      'personName': row['person_name']?.toString() ?? '',
      'personPhoto': row['person_photo']?.toString() ?? '',
      'immobileName': row['immobile_name']?.toString() ?? '',
      'immobilePhoto': row['immobile_photo']?.toString() ?? '',
      'immobileOwnerAccountId':
          row['immobile_owner_account_id']?.toString() ?? '',
      'immobileOwnerName': row['immobile_owner_name']?.toString() ?? '',
      'immobileOwnerPhoto': row['immobile_owner_photo']?.toString() ?? '',
      'otherName': display['otherName'],
      'otherPhoto': display['otherPhoto'],
      'lastMessagePreview': row['last_message_preview'] ?? '',
      'lastMessageAt': row['last_message_at'],
      'lastMessageSenderId': row['last_message_sender_id']?.toString() ?? '',
    };
  }
}
