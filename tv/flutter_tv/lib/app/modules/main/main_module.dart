import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/navigation/presenter/pages/splash_page.dart';

class MainModule extends Module {
  @override
  List<Bind> get binds => [
  ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const SplashPage()),
      ];
}
