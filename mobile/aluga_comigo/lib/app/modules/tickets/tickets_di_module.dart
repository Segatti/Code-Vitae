import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/ticket_datasource.dart';
import 'data/repositories/ticket_repository.dart';
import 'domain/repositories/ticket_repository.dart' as domain;
import 'domain/usecases/add_ticket_comment.dart';
import 'domain/usecases/create_support_ticket.dart';
import 'domain/usecases/get_ticket_detail.dart';
import 'domain/usecases/list_tickets_page.dart';
import 'domain/usecases/set_ticket_reaction.dart';
import 'ui/controllers/create_ticket_controller.dart';
import 'ui/controllers/ticket_detail_controller.dart';
import 'ui/controllers/tickets_controller.dart';

class TicketsDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<ITicketDatasource>(TicketDatasource.new);
    c.addSingleton<domain.ITicketRepository>(TicketRepository.new);
    c.addSingleton<IListTicketsPage>(ListTicketsPage.new);
    c.addSingleton<ICreateSupportTicket>(CreateSupportTicket.new);
    c.addSingleton<IGetTicketDetail>(GetTicketDetail.new);
    c.addSingleton<ISetTicketReaction>(SetTicketReaction.new);
    c.addSingleton<IAddTicketComment>(AddTicketComment.new);
    c.addLazySingleton<ITicketsController>(TicketsController.new);
    c.addLazySingleton<ICreateTicketController>(CreateTicketController.new);
    c.addLazySingleton<ITicketDetailController>(TicketDetailController.new);
  }
}
