import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../../shared/domain/extends/result.dart';
import '../../domain/entities/create_ticket_input.dart';
import '../../domain/entities/support_ticket_detail.dart';
import '../../domain/entities/ticket_list_filters.dart';
import '../../domain/entities/ticket_page.dart';
import '../../domain/enums/ticket_reaction.dart';
import '../../domain/repositories/ticket_repository.dart' as domain;
import '../datasources/ticket_datasource.dart';

class TicketRepository implements domain.ITicketRepository {
  final ITicketDatasource datasource;

  const TicketRepository(this.datasource);

  @override
  AsyncResult<TicketPage> listTickets({
    required int page,
    required TicketListFilters filters,
  }) async {
    return datasource
        .listTickets(page: page, filters: filters)
        .then((models) {
          final items = models.map((m) => m.toEntity()).toList();
          return TicketPage(
            items: items,
            hasMore: items.length >= ITicketDatasource.pageSize,
          );
        })
        .toAsyncResult();
  }

  @override
  AsyncResult<Unit> createTicket(CreateTicketInput input) async {
    return datasource
        .insertTicket(
          title: input.title,
          category: input.category,
          description: input.description,
        )
        .toAsyncResult();
  }

  @override
  AsyncResult<SupportTicketDetail> getTicketDetail(String ticketId) async {
    return datasource
        .getTicketById(ticketId)
        .then(
          (model) => SupportTicketDetail(
            ticket: model.toEntity(),
            comments: model.comments.map((c) => c.toEntity()).toList(),
          ),
        )
        .toAsyncResult();
  }

  @override
  AsyncResult<Unit> setTicketReaction({
    required String ticketId,
    required TicketReaction? reaction,
  }) async {
    return datasource
        .setReaction(ticketId: ticketId, reaction: reaction)
        .then((_) {})
        .toAsyncResult();
  }

  @override
  AsyncResult<Unit> addTicketComment({
    required String ticketId,
    required String body,
  }) async {
    return datasource
        .addComment(ticketId: ticketId, body: body)
        .toAsyncResult();
  }
}
