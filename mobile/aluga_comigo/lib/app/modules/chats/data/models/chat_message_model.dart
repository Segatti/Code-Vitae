import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final bool isFromUser;
  final String content;
  final String messageType;
  final DateTime? createdAt;

  const ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.isFromUser,
    required this.content,
    this.messageType = 'text',
    this.createdAt,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    final rawAt = map['createdAt'];
    if (rawAt is String && rawAt.isNotEmpty) {
      createdAt = DateTime.tryParse(rawAt);
    }

    return ChatMessageModel(
      id: map['id']?.toString() ?? '',
      chatId: map['chatId']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      isFromUser: map['isFromUser'] == true,
      content: map['content']?.toString() ?? '',
      messageType: map['messageType']?.toString() ?? 'text',
      createdAt: createdAt,
    );
  }

  ChatMessage toEntity() => ChatMessage(
        id: id,
        chatId: chatId,
        senderId: senderId,
        isFromUser: isFromUser,
        content: content,
        messageType: messageType,
        createdAt: createdAt,
      );
}
