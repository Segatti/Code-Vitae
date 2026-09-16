import '../../../modules/auth/domain/enums/type_user.dart';

/// Rotas iniciais e destaques da bottom bar por tipo de conta.
abstract final class StartNavigationHelper {
  /// Rota após login.
  static String homeRouteFor(TypeUser typeUser) {
    return switch (typeUser) {
      TypeUser.person => '/start/customers/',
      TypeUser.immobile => '/start/likes/',
      TypeUser.none => '/start/customers/',
    };
  }

  static bool isPersonSwipeRoute(String path) {
    return path.contains('/customers') || path.contains('/houses');
  }

  static bool isImmobileOwnerSwipeRoute(String path) {
    return path.contains('/customers') || path.contains('/houses');
  }

  static int navigationIndexForPath(String path, TypeUser typeUser) {
    if (path.contains('/likes')) return 2;
    if (path.contains('/chats')) return 3;
    if (path.contains('/houses')) return 1;
    if (path.contains('/customers')) return 0;
    return switch (typeUser) {
      TypeUser.person => 0,
      TypeUser.immobile => 2,
      TypeUser.none => 0,
    };
  }
}
