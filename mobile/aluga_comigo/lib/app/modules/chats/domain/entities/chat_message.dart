class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final bool isFromUser;
  final String content;
  final String messageType;
  final DateTime? createdAt;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.isFromUser,
    required this.content,
    this.messageType = 'text',
    this.createdAt,
  });
}
