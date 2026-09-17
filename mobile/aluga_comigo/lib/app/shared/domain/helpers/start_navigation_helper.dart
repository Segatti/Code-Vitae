import '../../../modules/auth/domain/enums/type_user.dart';

/// Rotas iniciais e destaques da bottom bar por tipo de conta.
abstract final class StartNavigationHelper {
  /// Rota após login.
  static String homeRouteFor(TypeUser typeUser) {
    return switch (typeUser) {
      TypeUser.person => '/start/customers/',
      TypeUser.immobile => '/start/my-immobiles/',
      TypeUser.none => '/start/customers/',
    };
  }

  static bool isPersonSwipeRoute(String path) {
    return path.contains('/customers') || path.contains('/houses');
  }

  static bool isImmobileOwnerSwipeRoute(String path) {
    return path.contains('/customers') || path.contains('/houses');
  }

  /// Rotas na ordem dos índices da bottom bar.
  static List<String> tabRoutesFor(TypeUser typeUser) {
    return switch (typeUser) {
      TypeUser.immobile => [
        '/start/my-immobiles/',
        '/start/likes/',
        '/start/chats/',
      ],
      TypeUser.person || TypeUser.none => [
        '/start/customers/',
        '/start/houses/',
        '/start/likes/',
        '/start/chats/',
      ],
    };
  }

  static int navigationIndexForPath(String path, TypeUser typeUser) {
    if (typeUser == TypeUser.immobile) {
      if (path.contains('/my-immobiles')) return 0;
      if (path.contains('/likes')) return 1;
      if (path.contains('/chats')) return 2;
      return 0;
    }

    if (path.contains('/likes')) return 2;
    if (path.contains('/chats')) return 3;
    if (path.contains('/houses')) return 1;
    if (path.contains('/customers')) return 0;
    return 0;
  }
}
