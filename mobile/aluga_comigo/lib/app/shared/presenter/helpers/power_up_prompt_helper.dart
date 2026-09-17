import 'package:aluga_comigo/app/shared/presenter/helpers/inventory_prompt_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

abstract final class PowerUpPromptHelper {
  static Future<void> promptForIncomingLikes(BuildContext context) async {
    final goToStore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'PowerUp necessário',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Para ver quem curtiu você e dar match, ative um PowerUp na loja.',
          style: GoogleFonts.rubik(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Comprar PowerUp'),
          ),
        ],
      ),
    );

    if (goToStore == true && context.mounted) {
      context.pushNamed(InventoryPromptHelper.storeRoute);
    }
  }

  static Future<void> promptForAdditionalImmobileListing(
    BuildContext context,
  ) async {
    final goToStore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'PowerUp necessário',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Para anunciar mais de um imóvel na sua conta, é preciso ter um '
          'PowerUp ativo. Ative na loja e tente novamente.',
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
      context.pushNamed(InventoryPromptHelper.storeRoute);
    }
  }
}
