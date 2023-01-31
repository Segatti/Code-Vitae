import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/modules/navigation/presenter/pages/morty_verso_page.dart';

import '../settings/settings_module.dart';
import 'presenter/pages/profile_page.dart';
import 'presenter/pages/pdf_preview_page.dart';
import 'presenter/pages/splash_page.dart';
import 'presenter/pages/start_page.dart';
import 'presenter/stores/profile_store.dart';
import 'presenter/stores/pdf_preview_store.dart';

class NavigationModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => ProfileStore(i(), i(), i())),
    Bind.factory((i) => PdfPreviewStore(i(), i(), i())),
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
          child: (_, __) => const ProfilePage(),
        ),
        ChildRoute(
          '/morty_verso',
          child: (_, __) => const MortyVersoPage(),
        ),
        ModuleRoute(
          '/settings',
          module: SettingsModule(),
        ),
      ],
    ),
    ChildRoute(
      '/pdf',
      child: (_, args) => PdfPreviewPage(
        charactersIdList: args.data['characters_id'],
        episodesIdList: args.data['locations_id'],
        locationsIdList: args.data['episodes_id'],
      ),
    )
  ];
}
