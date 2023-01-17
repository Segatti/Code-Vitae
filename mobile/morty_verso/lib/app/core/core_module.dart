import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/stores/bottom_navigation_bar_store.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => BottomNavigationBarStore(), export: true),
  ];

  @override
  final List<ModularRoute> routes = [];

}