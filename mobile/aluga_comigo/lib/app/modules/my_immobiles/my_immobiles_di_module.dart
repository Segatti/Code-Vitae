import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/my_immobiles_datasource.dart';
import 'data/repositories/my_immobiles_repository.dart';
import 'domain/repositories/my_immobiles_repository.dart';
import 'domain/usecases/create_owned_immobile_listing.dart';
import 'domain/usecases/list_owned_immobiles.dart';
import 'ui/controllers/my_immobiles_controller.dart';

class MyImmobilesDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IMyImmobilesDatasource>(MyImmobilesDatasource.new);
    c.addSingleton<IMyImmobilesRepository>(MyImmobilesRepository.new);
    c.addLazySingleton<IListOwnedImmobiles>(ListOwnedImmobiles.new);
    c.addLazySingleton<ICreateOwnedImmobileListing>(
      CreateOwnedImmobileListing.new,
    );
    c.add<IMyImmobilesController>(MyImmobilesController.new);
  }
}
