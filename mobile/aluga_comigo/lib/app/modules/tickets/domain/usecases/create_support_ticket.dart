import 'package:result_dart/result_dart.dart';

import '../entities/create_ticket_input.dart';
import '../repositories/ticket_repository.dart';

abstract interface class ICreateSupportTicket {
  AsyncResult<Unit> call(CreateTicketInput input);
}

class CreateSupportTicket implements ICreateSupportTicket {
  final ITicketRepository repository;

  const CreateSupportTicket(this.repository);

  @override
  AsyncResult<Unit> call(CreateTicketInput input) =>
      repository.createTicket(input);
}
