import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/modules/episodes/locations_module.dart';
import 'package:morty_verso/app/modules/locations/locations_module.dart';

import 'app_store.dart';
import 'core/core_module.dart';
import 'core/presenter/pages/favorite_page.dart';
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
    // TODO: Verificar porque esses módulos não estão funcionando sem importar antes
    CharactersModule(),
    LocationsModule(),
    EpisodesModule(),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: NavigationModule()),
    ModuleRoute(
      '/characters',
      module: CharactersModule(),
    ),
    ModuleRoute(
      '/locations',
      module: LocationsModule(),
    ),
    ModuleRoute(
      '/episodes',
      module: EpisodesModule(),
    ),
    ChildRoute(
      '/favorites/:type',
      child: (context, args) => FavoritePage(favoriteType: args.params['type']),
      transition: TransitionType.rightToLeft,
    )
  ];
}
