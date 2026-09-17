class ChatImmobileOffer {
  final String id;
  final String chatId;
  final String immobileId;
  final String immobileName;
  final String immobilePhoto;
  final DateTime? createdAt;

  const ChatImmobileOffer({
    required this.id,
    required this.chatId,
    required this.immobileId,
    this.immobileName = '',
    this.immobilePhoto = '',
    this.createdAt,
  });
}
