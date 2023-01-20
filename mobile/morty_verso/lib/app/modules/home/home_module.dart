import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/modules/home/presenter/pages/pdf_preview_page.dart';
import 'package:morty_verso/app/modules/home/presenter/stores/pdf_preview_store.dart';

import '../characters/characters_module.dart';
import '../settings/settings_module.dart';
import 'presenter/pages/home_page.dart';
import 'presenter/pages/start_page.dart';
import 'presenter/stores/home_store.dart';

class HomeModule extends Module {
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
    ChildRoute(
      Modular.initialRoute,
      child: (_, __) => const StartPage(),
      children: [
        ChildRoute(
          '/home',
          child: (context, args) => const HomePage(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/characters_navigation',
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
