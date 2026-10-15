import '../enums/ticket_category.dart';
import '../enums/ticket_reaction.dart';
import '../enums/ticket_status.dart';

class SupportTicket {
  final String id;
  final String title;
  final TicketCategory category;
  final String description;
  final DateTime createdAt;
  final TicketStatus status;
  final TicketReaction? userReaction;

  const SupportTicket({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
    this.status = TicketStatus.open,
    this.userReaction,
  });

  SupportTicket copyWith({
    TicketStatus? status,
    TicketReaction? userReaction,
    bool clearReaction = false,
  }) {
    return SupportTicket(
      id: id,
      title: title,
      category: category,
      description: description,
      createdAt: createdAt,
      status: status ?? this.status,
      userReaction: clearReaction ? null : (userReaction ?? this.userReaction),
    );
  }
}
