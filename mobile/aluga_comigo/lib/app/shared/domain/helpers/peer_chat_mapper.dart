import 'chat_participant_helper.dart';
import '../typedefs/json.dart';

class PeerChatMapper {
  static Json fromRow(Json row, String currentUserId) {
    final display = ChatParticipantHelper.peerDisplayFromRow(row, currentUserId);

    return {
      'id': row['id']?.toString() ?? '',
      'personId': '',
      'immobileId': '',
      'peerPersonId': display['peerPersonId']?.toString() ?? '',
      'otherName': display['otherName'],
      'otherPhoto': display['otherPhoto'],
      'lastMessagePreview': row['last_message_preview'] ?? '',
      'lastMessageAt': row['last_message_at'],
      'isPersonPeerChat': true,
    };
  }
}
