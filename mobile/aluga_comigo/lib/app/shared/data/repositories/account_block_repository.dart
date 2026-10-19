import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../domain/extends/result.dart';
import '../../domain/repositories/account_block_repository.dart';
import '../datasources/account_block_datasource.dart';
import '../services/session_service.dart';

class AccountBlockRepository implements IAccountBlockRepository {
  final IAccountBlockDatasource datasource;

  const AccountBlockRepository(this.datasource);

  String? get _blockerId => SessionService.customer?.id;

  @override
  AsyncResult<Unit> blockAccount(String blockedAccountId) async {
    final blockerId = _blockerId;
    if (blockerId == null || blockerId.isEmpty) {
      return Failure(Exception('Usuário não autenticado'));
    }
    if (blockedAccountId.isEmpty || blockedAccountId == blockerId) {
      return Failure(Exception('Conta inválida para bloqueio'));
    }

    return datasource
        .insertBlock(
          blockerAccountId: blockerId,
          blockedAccountId: blockedAccountId,
        )
        .then((_) => unit)
        .toAsyncResult();
  }

  @override
  AsyncResult<List<String>> listBlockedAccountIds() async {
    final blockerId = _blockerId;
    if (blockerId == null || blockerId.isEmpty) {
      return const Success([]);
    }
    return datasource.listBlockedAccountIds(blockerId).toAsyncResult();
  }
}
