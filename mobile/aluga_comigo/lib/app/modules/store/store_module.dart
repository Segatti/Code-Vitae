import 'package:aluga_comigo/app/modules/store/ui/controllers/store_controller.dart';
import 'package:aluga_comigo/app/modules/store/ui/pages/store_page.dart';
import 'package:aluga_comigo/app/shared/domain/transitions/app_transitions.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StoreModule extends Module {
  @override
  String? get path => '/store';

  @override
  void register(ModularContext c) {
    c.add<IStoreController>(StoreController.new);
    c.route(
      '/',
      transition: AppTransitions.rightToLeft,
      child: (_, _) => const StorePage(),
    );
  }
}
