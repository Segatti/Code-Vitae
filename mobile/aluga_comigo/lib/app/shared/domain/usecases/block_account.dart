import 'package:result_dart/result_dart.dart';

import '../repositories/account_block_repository.dart';

abstract interface class IBlockAccount {
  AsyncResult<Unit> call(String blockedAccountId);
}

class BlockAccount implements IBlockAccount {
  final IAccountBlockRepository repository;

  const BlockAccount(this.repository);

  @override
  AsyncResult<Unit> call(String blockedAccountId) =>
      repository.blockAccount(blockedAccountId);
}
