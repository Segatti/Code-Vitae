import 'package:aluga_comigo/app/modules/auth/domain/enums/type_immobile.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class IncompleteProfileHelper {
  static bool isProfileComplete(CustomerModel? model) {
    if (model == null) return false;

    switch (model) {
      case PersonCustomerModel _:
        return model.name.isNotEmpty &&
            model.dateBirth.isNotEmpty &&
            model.photos.isNotEmpty &&
            (model.shortDescription.isNotEmpty ||
                model.longDescription.isNotEmpty) &&
            model.cityState.isNotEmpty &&
            model.phone.isNotEmpty &&
            model.gender.isNotEmpty;
      case ImmobileCustomerModel _:
        return model.cep.isNotEmpty &&
            model.price > 0 &&
            model.photos.isNotEmpty &&
            (model.shortDescription.isNotEmpty ||
                model.longDescription.isNotEmpty) &&
            model.cityState.isNotEmpty &&
            model.phone.isNotEmpty &&
            model.typeImmobile != TypeImmobile.none;
    }
  }

  static Future<void> showIncompleteProfileDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Color(0XFFDF924B),
                ),
                const Gap(16),
                Text(
                  'Perfil Incompleto',
                  style: GoogleFonts.rubik(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(16),
                Text(
                  'Você precisa completar seu perfil para visualizar os detalhes dos outros usuários.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(fontSize: 16, color: Colors.black54),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.pushNamed('/config/profile');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFDF924B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Preencher',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showEntryPromptIfNeeded(BuildContext context) async {
    final customer = SessionService.customer;
    if (customer == null || isProfileComplete(customer)) return;
    if (SessionService.incompleteProfileEntryPromptShown) return;

    SessionService.incompleteProfileEntryPromptShown = true;
    await showIncompleteProfileDialog(context);
  }

  static Future<bool> canShowDetails(BuildContext context) async {
    if (isProfileComplete(SessionService.customer)) {
      return true;
    }

    await showIncompleteProfileDialog(context);
    return false;
  }
}
