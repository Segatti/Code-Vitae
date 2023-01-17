import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/core_module.dart';
import './modules/characters/characters_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  List<Module> imports = [
    CoreModule(),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: CharactersModule()),
  ];
}
