import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/infra/services/local_storage_service.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/stores/bottom_navigation_bar_store.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    // Services
    Bind.lazySingleton((i) => LocalStorageService(i()), export: true),

    // Stores
    Bind.factory((i) => BottomNavigationBarStore(), export: true),
  ];

  @override
  final List<ModularRoute> routes = [];

}