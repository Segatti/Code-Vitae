import 'package:material_ui/material_ui.dart';
import '../../domain/entities/support_ticket_detail.dart';
import '../../domain/usecases/add_ticket_comment.dart';
import '../../domain/usecases/get_ticket_detail.dart';

abstract interface class ITicketDetailController extends ChangeNotifier {
  bool loading = false;
  bool submittingComment = false;
  String errorMessage = '';
  SupportTicketDetail? detail;

  Future<void> load(String ticketId);
  Future<void> sendComment(String body);
}

class TicketDetailController extends ITicketDetailController {
  final IGetTicketDetail _getTicketDetail;
  final IAddTicketComment _addTicketComment;

  TicketDetailController(this._getTicketDetail, this._addTicketComment);

  String? _ticketId;

  @override
  Future<void> load(String ticketId) async {
    _ticketId = ticketId;
    loading = true;
    errorMessage = '';
    notifyListeners();

    final result = await _getTicketDetail(ticketId);
    loading = false;
    result.fold(
      (data) {
        detail = data;
        errorMessage = '';
      },
      (failure) {
        detail = null;
        errorMessage = failure.toString().replaceFirst('Exception: ', '');
      },
    );
    notifyListeners();
  }

  @override
  Future<void> sendComment(String body) async {
    final ticketId = _ticketId;
    final current = detail;
    if (ticketId == null || current == null) return;
    if (!current.ticket.status.isOpen) return;

    final trimmed = body.trim();
    if (trimmed.isEmpty) return;

    submittingComment = true;
    errorMessage = '';
    notifyListeners();

    final result = await _addTicketComment(ticketId: ticketId, body: trimmed);
    submittingComment = false;

    await result.fold(
      (_) async {
        await load(ticketId);
      },
      (failure) async {
        errorMessage = failure.toString().replaceFirst('Exception: ', '');
        notifyListeners();
      },
    );
  }
}
