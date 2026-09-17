import 'package:aluga_comigo/app/modules/auth/domain/enums/type_user.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

abstract final class InventoryPromptHelper {
  static const storeRoute = '/store/';

  /// Favorito pessoa→imóvel consome Super Chat.
  static bool actionUsesSuperChat(
    MatchType matchType,
    CustomerModel target,
  ) {
    if (matchType != MatchType.favorite) return false;
    final sessionType = SessionService.customer?.typeUser ?? TypeUser.none;
    return sessionType == TypeUser.person &&
        target.typeUser == TypeUser.immobile;
  }

  /// Super Star (demais favoritos com pessoa envolvida).
  static bool actionUsesSuperStar(
    MatchType matchType,
    CustomerModel target,
  ) {
    if (matchType != MatchType.favorite) return false;
    return !actionUsesSuperChat(matchType, target);
  }

  static bool hasSuperChatBalance() =>
      SessionService.inventory.superChatBalance > 0;

  static bool hasSuperStarBalance() =>
      SessionService.inventory.superStarBalance > 0;

  static Future<bool> ensureSuperChatAvailable(BuildContext context) async {
    if (hasSuperChatBalance()) return true;
    await promptSuperChatPurchase(context);
    return false;
  }

  /// Retorna `true` se pode seguir com a ação; se não houver saldo, abre o pop-up.
  static Future<bool> ensureSuperStarAvailable(BuildContext context) async {
    if (hasSuperStarBalance()) return true;
    await promptSuperStarPurchase(context);
    return false;
  }

  static Future<void> promptSuperStarPurchase(BuildContext context) async {
    final goToStore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Sem Super Star',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Você não tem Super Star disponível. Compre na loja para '
          'destacar este perfil.',
          style: GoogleFonts.rubik(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Comprar'),
          ),
        ],
      ),
    );

    if (goToStore == true && context.mounted) {
      context.pushNamed(storeRoute);
    }
  }

  static Future<void> promptSuperChatPurchase(BuildContext context) async {
    final goToStore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Sem Super Chat',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Você não tem Super Chat disponível. Compre na loja para '
          'enviar uma mensagem destacada ao imóvel.',
          style: GoogleFonts.rubik(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Comprar'),
          ),
        ],
      ),
    );

    if (goToStore == true && context.mounted) {
      context.pushNamed(storeRoute);
    }
  }
}
