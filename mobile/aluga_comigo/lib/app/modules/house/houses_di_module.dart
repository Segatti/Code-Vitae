import 'package:aluga_comigo/app/modules/house/ui/controllers/houses_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HousesDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addLazySingleton<IHousesController>(HousesController.new);
  }
}
