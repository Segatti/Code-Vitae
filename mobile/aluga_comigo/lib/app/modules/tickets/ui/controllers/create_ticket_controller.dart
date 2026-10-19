import 'package:material_ui/material_ui.dart';

import '../../../../shared/data/services/analytics_service.dart';
import '../../../../shared/domain/analytics/analytics_events.dart';
import '../../domain/entities/create_ticket_input.dart';
import '../../domain/enums/ticket_category.dart';
import '../../domain/usecases/create_support_ticket.dart';

abstract interface class ICreateTicketController extends ChangeNotifier {
  bool submitting = false;
  String errorMessage = '';
  TicketCategory category = TicketCategory.suggestion;
  String? reportedAccountId;
  String? reportContext;

  void applyPrefill({
    TicketCategory? category,
    String? title,
    String? description,
    String? reportedAccountId,
    String? reportContext,
  });

  void setCategory(TicketCategory value);
  Future<bool> submit({
    required String title,
    required String description,
  });
}

class CreateTicketController extends ICreateTicketController {
  final ICreateSupportTicket _createSupportTicket;
  final IAnalyticsService _analytics;

  CreateTicketController(this._createSupportTicket, this._analytics);

  @override
  void applyPrefill({
    TicketCategory? category,
    String? title,
    String? description,
    String? reportedAccountId,
    String? reportContext,
  }) {
    if (category != null) this.category = category;
    this.reportedAccountId = reportedAccountId;
    this.reportContext = reportContext;
    notifyListeners();
  }

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
        reportedAccountId: reportedAccountId,
        reportContext: reportContext,
      ),
    );

    submitting = false;

    final ok = result.fold((_) => true, (_) => false);
    if (ok) {
      if (category == TicketCategory.report) {
        await _analytics.logEvent(
          AnalyticsEvents.reportSubmitted,
          parameters: {
            if (reportContext != null)
              AnalyticsParams.reportContext: reportContext!,
          },
        );
      }
      errorMessage = '';
      notifyListeners();
      return true;
    }

    result.fold(
      (_) {},
      (failure) {
        errorMessage = failure.toString().replaceFirst('Exception: ', '');
        notifyListeners();
      },
    );
    return false;
  }
}
