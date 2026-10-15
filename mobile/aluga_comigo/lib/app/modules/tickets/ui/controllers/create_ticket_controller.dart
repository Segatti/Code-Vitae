import 'package:material_ui/material_ui.dart';
import '../../domain/entities/create_ticket_input.dart';
import '../../domain/enums/ticket_category.dart';
import '../../domain/usecases/create_support_ticket.dart';

abstract interface class ICreateTicketController extends ChangeNotifier {
  bool submitting = false;
  String errorMessage = '';
  TicketCategory category = TicketCategory.suggestion;

  void setCategory(TicketCategory value);
  Future<bool> submit({
    required String title,
    required String description,
  });
}

class CreateTicketController extends ICreateTicketController {
  final ICreateSupportTicket _createSupportTicket;

  CreateTicketController(this._createSupportTicket);

  @override
  void setCategory(TicketCategory value) {
    category = value;
    notifyListeners();
  }

  @override
  Future<bool> submit({
    required String title,
    required String description,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedDescription = description.trim();

    if (trimmedTitle.length < 3) {
      errorMessage = 'Informe um título com pelo menos 3 caracteres.';
      notifyListeners();
      return false;
    }
    if (trimmedDescription.length < 10) {
      errorMessage = 'Descreva com pelo menos 10 caracteres.';
      notifyListeners();
      return false;
    }

    submitting = true;
    errorMessage = '';
    notifyListeners();

    final result = await _createSupportTicket(
      CreateTicketInput(
        title: trimmedTitle,
        category: category,
        description: trimmedDescription,
      ),
    );

    submitting = false;
    return result.fold(
      (_) {
        errorMessage = '';
        notifyListeners();
        return true;
      },
      (failure) {
        errorMessage = failure.toString().replaceFirst('Exception: ', '');
        notifyListeners();
        return false;
      },
    );
  }
}
