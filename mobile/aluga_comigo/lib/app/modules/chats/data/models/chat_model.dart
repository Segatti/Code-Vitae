import '../../domain/entities/chat.dart';

class ChatModel {
  final String id;
  final String personId;
  final String immobileId;
  final String otherName;
  final String otherPhoto;
  final String lastMessagePreview;
  final DateTime? lastMessageAt;

  const ChatModel({
    required this.id,
    required this.personId,
    required this.immobileId,
    required this.otherName,
    required this.otherPhoto,
    this.lastMessagePreview = '',
    this.lastMessageAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    DateTime? lastAt;
    final rawAt = map['lastMessageAt'];
    if (rawAt is String && rawAt.isNotEmpty) {
      lastAt = DateTime.tryParse(rawAt);
    }

    return ChatModel(
      id: map['id']?.toString() ?? '',
      personId: map['personId']?.toString() ?? '',
      immobileId: map['immobileId']?.toString() ?? '',
      otherName: map['otherName']?.toString() ?? '',
      otherPhoto: map['otherPhoto']?.toString() ?? '',
      lastMessagePreview: map['lastMessagePreview']?.toString() ?? '',
      lastMessageAt: lastAt,
    );
  }

  Chat toEntity() => Chat(
        id: id,
        personId: personId,
        immobileId: immobileId,
        otherName: otherName,
        otherPhoto: otherPhoto,
        lastMessagePreview: lastMessagePreview,
        lastMessageAt: lastMessageAt,
      );
}
