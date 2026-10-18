class ChatMessageInsertEvent {
  final String chatId;
  final String senderId;
  final String preview;
  final bool isPersonPeerChat;

  const ChatMessageInsertEvent({
    required this.chatId,
    required this.senderId,
    required this.preview,
    required this.isPersonPeerChat,
  });
}
