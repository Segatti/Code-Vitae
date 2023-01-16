import 'package:flutter_modular/flutter_modular.dart';
import './modules/characters/characters_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: CharactersModule()),
  ];
}
