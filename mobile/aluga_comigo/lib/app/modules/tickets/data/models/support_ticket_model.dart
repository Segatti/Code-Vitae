import '../../domain/entities/support_ticket.dart';
import '../../domain/enums/ticket_category.dart';
import '../../domain/enums/ticket_reaction.dart';
import '../../domain/enums/ticket_status.dart';
import 'ticket_comment_model.dart';

class SupportTicketModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String status;
  final DateTime? createdAt;
  final TicketReaction? userReaction;
  final List<TicketCommentModel> comments;

  const SupportTicketModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.status,
    this.createdAt,
    this.userReaction,
    this.comments = const [],
  });

  factory SupportTicketModel.fromMap(
    Map<String, dynamic> map, {
    String? currentAccountId,
  }) {
    DateTime? createdAt;
    final raw = map['created_at'] ?? map['createdAt'];
    if (raw is String && raw.isNotEmpty) {
      createdAt = DateTime.tryParse(raw);
    }

    TicketReaction? reaction;
    final reactionsRaw = map['support_ticket_reactions'];
    if (reactionsRaw is List && reactionsRaw.isNotEmpty) {
      for (final item in reactionsRaw) {
        if (item is! Map) continue;
        final ownerId = item['account_id']?.toString();
        if (currentAccountId != null &&
            ownerId != null &&
            ownerId != currentAccountId) {
          continue;
        }
        reaction = TicketReaction.fromStorage(
          item['reaction']?.toString(),
        );
        break;
      }
    }

    final commentsRaw = map['support_ticket_comments'];
    final comments = <TicketCommentModel>[];
    if (commentsRaw is List) {
      for (final item in commentsRaw) {
        if (item is Map) {
          comments.add(
            TicketCommentModel.fromMap(Map<String, dynamic>.from(item)),
          );
        }
      }
      comments.sort(
        (a, b) => (a.createdAt ?? DateTime(0)).compareTo(
          b.createdAt ?? DateTime(0),
        ),
      );
    }

    return SupportTicketModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? 'suggestion',
      description: map['description']?.toString() ?? '',
      status: map['status']?.toString() ?? 'open',
      createdAt: createdAt,
      userReaction: reaction,
      comments: comments,
    );
  }

  SupportTicket toEntity() => SupportTicket(
    id: id,
    title: title,
    category: TicketCategory.fromStorage(category),
    description: description,
    createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    status: TicketStatus.fromStorage(status),
    userReaction: userReaction,
  );
}
