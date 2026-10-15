import 'package:result_dart/result_dart.dart' show AsyncResult, Unit;

import '../repositories/ticket_repository.dart';

abstract interface class IAddTicketComment {
  AsyncResult<Unit> call({required String ticketId, required String body});
}

class AddTicketComment implements IAddTicketComment {
  final ITicketRepository repository;

  const AddTicketComment(this.repository);

  @override
  AsyncResult<Unit> call({required String ticketId, required String body}) =>
      repository.addTicketComment(ticketId: ticketId, body: body);
}
