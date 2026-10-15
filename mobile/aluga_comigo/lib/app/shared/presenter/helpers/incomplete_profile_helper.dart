import 'package:aluga_comigo/app/modules/auth/domain/enums/type_immobile.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/app_message_dialog.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
    return showAppConfirmDialog(
      context: context,
      title: 'Perfil incompleto',
      message:
          'Você precisa completar seu perfil para visualizar os detalhes '
          'dos outros usuários.',
      confirmLabel: 'Preencher',
    ).then((goFill) {
      if (goFill == true && context.mounted) {
        context.pushNamed('/config/profile');
      }
    });
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
