import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final bool isFromUser;
  final String content;
  final String messageType;
  final DateTime? createdAt;
  final DateTime? readAt;

  const ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.isFromUser,
    required this.content,
    this.messageType = 'text',
    this.createdAt,
    this.readAt,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseAt(dynamic raw) {
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw);
      }
      return null;
    }

    return ChatMessageModel(
      id: map['id']?.toString() ?? '',
      chatId: map['chatId']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      isFromUser: map['isFromUser'] == true,
      content: map['content']?.toString() ?? '',
      messageType: map['messageType']?.toString() ?? 'text',
      createdAt: parseAt(map['createdAt']),
      readAt: parseAt(map['readAt']),
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
    readAt: readAt,
  );
}
