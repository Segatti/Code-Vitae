import 'package:aluga_comigo/app/modules/chats/ui/controllers/chats_list_controller.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/controllers/customers_controller.dart';
import 'package:aluga_comigo/app/modules/house/ui/controllers/houses_controller.dart';
import 'package:aluga_comigo/app/modules/tickets/ui/controllers/tickets_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Limpa feeds em memória ao encerrar sessão (controllers são singleton).
class FeedSessionHelper {
  FeedSessionHelper._();

  static void resetSwipeFeeds() {
    inject<ICustomersController>().resetFeedState();
    inject<IHousesController>().resetFeedState();
  }

  static void resetChatsList() {
    try {
      inject<IChatsListController>().resetSessionState();
    } catch (_) {}
  }

  static void resetTicketsList() {
    try {
      inject<ITicketsController>().resetSessionState();
    } catch (_) {}
  }

  /// Limpa estado em memória ao trocar de conta (singletons).
  static void resetSessionScopedControllers() {
    resetSwipeFeeds();
    resetChatsList();
    resetTicketsList();
  }
}
