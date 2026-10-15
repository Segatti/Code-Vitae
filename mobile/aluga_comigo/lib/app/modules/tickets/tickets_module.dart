import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui/pages/create_ticket_page.dart';
import 'ui/pages/ticket_detail_page.dart';
import 'ui/pages/tickets_page.dart';

class TicketsModule extends Module {
  @override
  String? get path => '/tickets';

  @override
  void register(ModularContext c) {
    c.route(
      '/',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const TicketsPage(),
    );
    c.route(
      '/new',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const CreateTicketPage(),
    );
    c.route(
      '/detail',
      transition: AppTransitions.rightToLeft,
      child: (_, state) {
        final map = state.arguments as Map<String, dynamic>? ?? {};
        final ticketId = map['ticketId']?.toString() ?? '';
        return TicketDetailPage(ticketId: ticketId);
      },
    );
  }
}
