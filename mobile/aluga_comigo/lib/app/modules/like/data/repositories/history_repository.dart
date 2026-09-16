import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../../shared/domain/extends/result.dart';
import '../datasources/history_datasource.dart';
import '../models/rejected_history_item.dart';

typedef RejectedHistoryResult = ({
  List<RejectedHistoryItem> persons,
  List<RejectedHistoryItem> immobiles,
});

abstract interface class IHistoryRepository {
  AsyncResult<RejectedHistoryResult> getRejectedHistory();
}

class HistoryRepository implements IHistoryRepository {
  final IHistoryDatasource datasource;

  const HistoryRepository(this.datasource);

  @override
  AsyncResult<RejectedHistoryResult> getRejectedHistory() {
    return datasource.getRejectedHistory().toAsyncResult();
  }
}
