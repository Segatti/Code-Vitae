import 'package:result_dart/result_dart.dart' show AsyncResult;

import '../entities/ticket_list_filters.dart';
import '../entities/ticket_page.dart';
import '../repositories/ticket_repository.dart';

abstract interface class IListTicketsPage {
  AsyncResult<TicketPage> call({
    required int page,
    required TicketListFilters filters,
  });
}

class ListTicketsPage implements IListTicketsPage {
  final ITicketRepository repository;

  const ListTicketsPage(this.repository);

  @override
  AsyncResult<TicketPage> call({
    required int page,
    required TicketListFilters filters,
  }) =>
      repository.listTickets(page: page, filters: filters);
}
