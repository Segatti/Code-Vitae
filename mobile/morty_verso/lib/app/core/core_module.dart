import 'package:flutter_modular/flutter_modular.dart';
import 'package:localstorage/localstorage.dart';

import 'domain/services/local_storage_service.dart';
import 'domain/usecases/get_value_local_storage.dart';
import 'domain/usecases/set_value_local_storage.dart';
import 'infra/services/local_storage_service.dart';
import 'presenter/widgets/view/stores/bottom_navigation_bar_store.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    // Services
    Bind.singleton<ILocalStorageService>((i) => LocalStorageService(i()),
        export: true),

    // Use cases
    Bind.singleton<IUCGetValueLocalStorage>(
        (i) => UCGetValueLocalStorage(localStorageService: i()),
        export: true),
    Bind.singleton<IUCSetValueLocalStorage>(
        (i) => UCSetValueLocalStorage(localStorageService: i()),
        export: true),

    // Stores
    Bind.factory<BottomNavigationBarStore>((i) => BottomNavigationBarStore(),
        export: true),

    // Dependecy
    Bind.singleton<LocalStorage>((i) => LocalStorage('local_storage'),
        export: true),
  ];

  @override
  final List<ModularRoute> routes = [];
}
