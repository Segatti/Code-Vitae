class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final bool isFromUser;
  final String content;
  final String messageType;
  final DateTime? createdAt;
  final DateTime? readAt;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.isFromUser,
    required this.content,
    this.messageType = 'text',
    this.createdAt,
    this.readAt,
  });

  bool get isSuperChat => messageType == 'superChat';

  bool get isReadByOther => readAt != null;
}
