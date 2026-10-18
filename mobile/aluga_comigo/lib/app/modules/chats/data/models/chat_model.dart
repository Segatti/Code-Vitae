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
  final String immobileOwnerAccountId;
  final String immobileOwnerName;
  final String immobileOwnerPhoto;
  final String otherName;
  final String otherPhoto;
  final String lastMessagePreview;
  final DateTime? lastMessageAt;
  final bool isPersonPeerChat;
  final int unreadCount;

  const ChatModel({
    required this.id,
    required this.personId,
    required this.immobileId,
    this.peerPersonId = '',
    this.personName = '',
    this.personPhoto = '',
    this.immobileName = '',
    this.immobilePhoto = '',
    this.immobileOwnerAccountId = '',
    this.immobileOwnerName = '',
    this.immobileOwnerPhoto = '',
    required this.otherName,
    required this.otherPhoto,
    this.lastMessagePreview = '',
    this.lastMessageAt,
    this.isPersonPeerChat = false,
    this.unreadCount = 0,
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
      immobileOwnerAccountId: map['immobileOwnerAccountId']?.toString() ?? '',
      immobileOwnerName: map['immobileOwnerName']?.toString() ?? '',
      immobileOwnerPhoto: map['immobileOwnerPhoto']?.toString() ?? '',
      otherName: map['otherName']?.toString() ?? '',
      otherPhoto: map['otherPhoto']?.toString() ?? '',
      lastMessagePreview: map['lastMessagePreview']?.toString() ?? '',
      lastMessageAt: lastAt,
      isPersonPeerChat: map['isPersonPeerChat'] == true,
      unreadCount: _parseUnreadCount(map['unreadCount']),
    );
  }

  static int _parseUnreadCount(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
    immobileOwnerAccountId: immobileOwnerAccountId,
    immobileOwnerName: immobileOwnerName,
    immobileOwnerPhoto: immobileOwnerPhoto,
    otherName: otherName,
    otherPhoto: otherPhoto,
    lastMessagePreview: lastMessagePreview,
    lastMessageAt: lastMessageAt,
    isPersonPeerChat: isPersonPeerChat,
    unreadCount: unreadCount,
  );
}
