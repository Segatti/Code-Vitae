import 'package:flutter_modular/flutter_modular.dart';

import 'app_store.dart';
import 'core/core_module.dart';
import 'modules/characters/characters_module.dart';
import 'modules/navigation/navigation_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton<AppStore>((i) => AppStore(i(), i())),
  ];

  @override
  List<Module> imports = [
    CoreModule(),
    CharactersModule(),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: NavigationModule()),
    ModuleRoute(
      '/characters',
      module: CharactersModule(),
    ),
  ];
}
