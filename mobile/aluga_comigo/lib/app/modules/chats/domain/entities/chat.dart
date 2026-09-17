import '../../../../shared/domain/helpers/chat_participant_helper.dart';

class Chat {
  final String id;
  final String personId;
  final String immobileId;
  final String peerPersonId;
  final String personName;
  final String personPhoto;
  final String immobileName;
  final String immobilePhoto;
  final String otherName;
  final String otherPhoto;
  final String lastMessagePreview;
  final DateTime? lastMessageAt;
  final bool isPersonPeerChat;

  /// Imóvel pelo qual a conversa foi aberta (metadado em [chats], não mensagem).
  String get contactListingId => immobileId;

  const Chat({
    required this.id,
    required this.personId,
    required this.immobileId,
    this.peerPersonId = '',
    this.personName = '',
    this.personPhoto = '',
    this.immobileName = '',
    this.immobilePhoto = '',
    required this.otherName,
    required this.otherPhoto,
    this.lastMessagePreview = '',
    this.lastMessageAt,
    this.isPersonPeerChat = false,
  });

  String otherParticipantAccountId(String currentAccountId) {
    return ChatParticipantHelper.otherParticipantId(
      currentAccountId: currentAccountId,
      personId: personId,
      immobileId: immobileId,
      peerPersonId: peerPersonId,
      isPersonPeerChat: isPersonPeerChat,
    );
  }

  /// Nome e foto do contato com base no ID da conta logada.
  ({String name, String photo}) otherParticipantDisplay(String currentAccountId) {
    if (isPersonPeerChat) {
      return (name: otherName, photo: otherPhoto);
    }
    final display = ChatParticipantHelper.personImmobileDisplayFromRow(
      {
        'person_id': personId,
        'immobile_id': immobileId,
        'person_name': personName,
        'person_photo': personPhoto,
        'immobile_name': immobileName,
        'immobile_photo': immobilePhoto,
      },
      currentAccountId,
    );
    return (
      name: display['otherName']?.toString() ?? otherName,
      photo: display['otherPhoto']?.toString() ?? otherPhoto,
    );
  }
}
