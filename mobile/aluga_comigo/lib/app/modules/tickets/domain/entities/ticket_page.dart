import 'support_ticket.dart';

class TicketPage {
  final List<SupportTicket> items;
  final bool hasMore;

  const TicketPage({
    required this.items,
    required this.hasMore,
  });
}
