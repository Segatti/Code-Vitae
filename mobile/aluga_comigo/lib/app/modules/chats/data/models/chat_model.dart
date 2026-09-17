import '../../domain/entities/chat.dart';

class ChatModel {
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

  const ChatModel({
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
      peerPersonId: map['peerPersonId']?.toString() ?? '',
      personName: map['personName']?.toString() ?? '',
      personPhoto: map['personPhoto']?.toString() ?? '',
      immobileName: map['immobileName']?.toString() ?? '',
      immobilePhoto: map['immobilePhoto']?.toString() ?? '',
      otherName: map['otherName']?.toString() ?? '',
      otherPhoto: map['otherPhoto']?.toString() ?? '',
      lastMessagePreview: map['lastMessagePreview']?.toString() ?? '',
      lastMessageAt: lastAt,
      isPersonPeerChat: map['isPersonPeerChat'] == true,
    );
  }

  Chat toEntity() => Chat(
    id: id,
    personId: personId,
    immobileId: immobileId,
    peerPersonId: peerPersonId,
    personName: personName,
    personPhoto: personPhoto,
    immobileName: immobileName,
    immobilePhoto: immobilePhoto,
    otherName: otherName,
    otherPhoto: otherPhoto,
    lastMessagePreview: lastMessagePreview,
    lastMessageAt: lastMessageAt,
    isPersonPeerChat: isPersonPeerChat,
  );
}
