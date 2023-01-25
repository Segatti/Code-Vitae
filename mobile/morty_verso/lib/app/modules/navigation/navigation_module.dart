import 'package:flutter_modular/flutter_modular.dart';

import '../characters/characters_module.dart';
import '../settings/settings_module.dart';
import 'presenter/pages/home_page.dart';
import 'presenter/pages/pdf_preview_page.dart';
import 'presenter/pages/splash_page.dart';
import 'presenter/pages/start_page.dart';
import 'presenter/stores/home_store.dart';
import 'presenter/stores/pdf_preview_store.dart';

class NavigationModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => HomeStore(i())),
    Bind.factory((i) => PdfPreviewStore(getMultipleCharacters: i())),
  ];

  @override
  List<Module> imports = [
    CharactersModule(),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => const SplashPage()),
    ChildRoute(
      '/navigation',
      child: (_, __) => const StartPage(),
      children: [
        ChildRoute(
          '/profile',
          child: (context, args) => const HomePage(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/morty_verso',
          module: CharactersModule(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/settings',
          module: SettingsModule(),
          transition: TransitionType.noTransition,
        ),
      ],
    ),
    ChildRoute('/pdf',
        child: (_, args) =>
            PdfPreviewPage(charactersIdList: args.data['characters_id']))
  ];
}
