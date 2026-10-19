import 'package:result_dart/result_dart.dart';

import '../repositories/account_block_repository.dart';

abstract interface class IListBlockedAccountIds {
  AsyncResult<List<String>> call();
}

class ListBlockedAccountIds implements IListBlockedAccountIds {
  final IAccountBlockRepository repository;

  const ListBlockedAccountIds(this.repository);

  @override
  AsyncResult<List<String>> call() => repository.listBlockedAccountIds();
}
