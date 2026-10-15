import 'support_ticket.dart';
import 'ticket_comment.dart';

class SupportTicketDetail {
  final SupportTicket ticket;
  final List<TicketComment> comments;

  const SupportTicketDetail({
    required this.ticket,
    required this.comments,
  });
}
