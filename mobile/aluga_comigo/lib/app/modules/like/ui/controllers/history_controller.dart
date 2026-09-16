import 'package:aluga_comigo/app/shared/domain/entities/failures.dart'
    as entity;
import 'package:aluga_comigo/app/shared/domain/errors/failure.dart' as app;
import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/models/rejected_history_item.dart';
import '../../domain/usecases/get_rejected_history.dart';

abstract interface class IHistoryController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<RejectedHistoryItem> persons = [];
  List<RejectedHistoryItem> immobiles = [];

  Future<Unit> initialize();
}

class HistoryController extends IHistoryController {
  final IGetRejectedHistory _getRejectedHistory;

  HistoryController(this._getRejectedHistory);

  @override
  Future<Unit> initialize() async {
    loadingList.add('loadHistory');
    errorMessage = '';
    notifyListeners();

    try {
      final result = await _getRejectedHistory();
      result.fold(
        (data) {
          persons = data.persons;
          immobiles = data.immobiles;
          errorMessage = '';
        },
        (failure) {
          persons = [];
          immobiles = [];
          errorMessage = switch (failure) {
            app.Failure(:final message) => message,
            entity.Failure(:final message) => message,
            _ => failure.toString(),
          };
        },
      );
    } finally {
      loadingList.remove('loadHistory');
      notifyListeners();
    }
    return unit;
  }
}
