import 'package:aluga_comigo/app/modules/customer/presenter/controllers/customers_controller.dart';
import 'package:aluga_comigo/app/modules/house/ui/controllers/houses_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Limpa feeds em memória ao encerrar sessão (controllers são singleton).
class FeedSessionHelper {
  FeedSessionHelper._();

  static void resetSwipeFeeds() {
    inject<ICustomersController>().resetFeedState();
    inject<IHousesController>().resetFeedState();
  }
}
