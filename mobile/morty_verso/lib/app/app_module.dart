import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/app_store.dart';
import 'package:morty_verso/app/core/core_module.dart';
import 'package:morty_verso/app/modules/home/home_module.dart';

import 'modules/characters/characters_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton<AppStore>((i) => AppStore()),
  ];

  @override
  List<Module> imports = [
    CoreModule(),
    CharactersModule(),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
