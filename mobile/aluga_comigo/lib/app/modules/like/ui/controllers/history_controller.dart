import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
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

  late final _loadCommand = Command0(_getRejectedHistory.call);

  @override
  Future<Unit> initialize() async {
    loadingList.add('loadHistory');
    notifyListeners();

    await _loadCommand.execute();

    loadingList.remove('loadHistory');
    final result = _loadCommand.value;
    result.when(
      data: (data) {
        persons = data.persons;
        immobiles = data.immobiles;
        errorMessage = '';
      },
      failure: (_) {
        errorMessage = 'Erro ao carregar histórico';
        persons = [];
        immobiles = [];
      },
      orElse: () {
        persons = [];
        immobiles = [];
      },
    );
    notifyListeners();
    return unit;
  }
}
