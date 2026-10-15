import 'package:aluga_comigo/app/shared/presenter/helpers/inventory_prompt_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/app_message_dialog.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

abstract final class PowerUpPromptHelper {
  static Future<void> promptForIncomingLikes(BuildContext context) async {
    final goToStore = await showAppConfirmDialog(
      context: context,
      title: 'PowerUp necessário',
      message:
          'Para ver quem curtiu você e dar match, ative um PowerUp na loja.',
      cancelLabel: 'Agora não',
      confirmLabel: 'Comprar PowerUp',
    );

    if (goToStore == true && context.mounted) {
      context.pushNamed(InventoryPromptHelper.storeRoute);
    }
  }

  static Future<void> promptForAdditionalImmobileListing(
    BuildContext context,
  ) async {
    final goToStore = await showAppConfirmDialog(
      context: context,
      title: 'PowerUp necessário',
      message:
          'Para anunciar mais de um imóvel na sua conta, é preciso ter um '
          'PowerUp ativo. Ative na loja e tente novamente.',
      cancelLabel: 'Agora não',
      confirmLabel: 'Comprar',
    );

    if (goToStore == true && context.mounted) {
      context.pushNamed(InventoryPromptHelper.storeRoute);
    }
  }
}
