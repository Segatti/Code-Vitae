import 'package:material_ui/material_ui.dart';

/// Chave do [Navigator] raiz — passada em [ModularApp.navigatorKey] no `main`.
abstract final class ModularNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static BuildContext? get context => key.currentContext;
}
