import 'package:result_dart/result_dart.dart' show AsyncResult;

import '../entities/support_ticket_detail.dart';
import '../repositories/ticket_repository.dart';

abstract interface class IGetTicketDetail {
  AsyncResult<SupportTicketDetail> call(String ticketId);
}

class GetTicketDetail implements IGetTicketDetail {
  final ITicketRepository repository;

  const GetTicketDetail(this.repository);

  @override
  AsyncResult<SupportTicketDetail> call(String ticketId) =>
      repository.getTicketDetail(ticketId);
}
