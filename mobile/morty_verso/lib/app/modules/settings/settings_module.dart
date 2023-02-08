import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/modules/settings/presenter/pages/settings_page.dart';
import 'package:morty_verso/app/modules/settings/presenter/stores/settings_store.dart';

class SettingsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory<SettingsStore>((i) => SettingsStore(i()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, __) => const SettingsPage(),
    ),
  ];
}
