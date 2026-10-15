import 'package:result_dart/result_dart.dart' show AsyncResult, Unit;

import '../entities/create_ticket_input.dart';
import '../entities/support_ticket_detail.dart';
import '../entities/ticket_list_filters.dart';
import '../entities/ticket_page.dart';
import '../enums/ticket_reaction.dart';

abstract interface class ITicketRepository {
  AsyncResult<TicketPage> listTickets({
    required int page,
    required TicketListFilters filters,
  });

  AsyncResult<Unit> createTicket(CreateTicketInput input);

  AsyncResult<SupportTicketDetail> getTicketDetail(String ticketId);

  AsyncResult<Unit> setTicketReaction({
    required String ticketId,
    required TicketReaction? reaction,
  });

  AsyncResult<Unit> addTicketComment({
    required String ticketId,
    required String body,
  });
}
