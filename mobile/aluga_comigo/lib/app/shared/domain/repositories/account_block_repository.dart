import 'package:result_dart/result_dart.dart';

abstract interface class IAccountBlockRepository {
  AsyncResult<Unit> blockAccount(String blockedAccountId);

  AsyncResult<List<String>> listBlockedAccountIds();
}
