import '../../domain/entities/ticket_comment.dart';

class TicketCommentModel {
  final String id;
  final String body;
  final DateTime? createdAt;

  const TicketCommentModel({
    required this.id,
    required this.body,
    this.createdAt,
  });

  factory TicketCommentModel.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    final raw = map['created_at'] ?? map['createdAt'];
    if (raw is String && raw.isNotEmpty) {
      createdAt = DateTime.tryParse(raw);
    }

    return TicketCommentModel(
      id: map['id']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      createdAt: createdAt,
    );
  }

  TicketComment toEntity() => TicketComment(
    id: id,
    body: body,
    createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
  );
}
