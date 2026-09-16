import 'package:result_dart/result_dart.dart';

import '../../data/repositories/history_repository.dart';

abstract interface class IGetRejectedHistory {
  AsyncResult<RejectedHistoryResult> call();
}

class GetRejectedHistory implements IGetRejectedHistory {
  final IHistoryRepository repository;

  const GetRejectedHistory(this.repository);

  @override
  AsyncResult<RejectedHistoryResult> call() {
    return repository.getRejectedHistory();
  }
}
