import '../../domain/entities/chat_immobile_offer.dart';

class ChatImmobileOfferModel {
  final String id;
  final String chatId;
  final String immobileId;
  final String immobileName;
  final String immobilePhoto;
  final DateTime? createdAt;

  const ChatImmobileOfferModel({
    required this.id,
    required this.chatId,
    required this.immobileId,
    this.immobileName = '',
    this.immobilePhoto = '',
    this.createdAt,
  });

  factory ChatImmobileOfferModel.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    final raw = map['createdAt'] ?? map['created_at'];
    if (raw is String && raw.isNotEmpty) {
      createdAt = DateTime.tryParse(raw);
    }

    return ChatImmobileOfferModel(
      id: map['id']?.toString() ?? '',
      chatId: map['chatId']?.toString() ?? map['chat_id']?.toString() ?? '',
      immobileId:
          map['immobileId']?.toString() ?? map['immobile_id']?.toString() ?? '',
      immobileName: map['immobileName']?.toString() ??
          map['immobile_name']?.toString() ??
          '',
      immobilePhoto: map['immobilePhoto']?.toString() ??
          map['immobile_photo']?.toString() ??
          '',
      createdAt: createdAt,
    );
  }

  ChatImmobileOffer toEntity() => ChatImmobileOffer(
        id: id,
        chatId: chatId,
        immobileId: immobileId,
        immobileName: immobileName,
        immobilePhoto: immobilePhoto,
        createdAt: createdAt,
      );
}
