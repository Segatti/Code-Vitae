import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/app_store.dart';
import 'package:morty_verso/app/core/core_module.dart';
import 'package:morty_verso/app/modules/navigation/navigation_module.dart';

import 'modules/characters/characters_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton<AppStore>((i) => AppStore(i(), i())),
  ];

  @override
  List<Module> imports = [
    CoreModule(),
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
