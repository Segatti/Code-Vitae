import 'package:result_dart/result_dart.dart' show AsyncResult, Unit;

import '../enums/ticket_reaction.dart';
import '../repositories/ticket_repository.dart';

abstract interface class ISetTicketReaction {
  AsyncResult<Unit> call({
    required String ticketId,
    required TicketReaction? reaction,
  });
}

class SetTicketReaction implements ISetTicketReaction {
  final ITicketRepository repository;

  const SetTicketReaction(this.repository);

  @override
  AsyncResult<Unit> call({
    required String ticketId,
    required TicketReaction? reaction,
  }) =>
      repository.setTicketReaction(ticketId: ticketId, reaction: reaction);
}
