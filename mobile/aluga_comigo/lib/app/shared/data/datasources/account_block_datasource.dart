import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/supabase_error_handler.dart';

abstract interface class IAccountBlockDatasource {
  Future<void> insertBlock({
    required String blockerAccountId,
    required String blockedAccountId,
  });

  Future<List<String>> listBlockedAccountIds(String blockerAccountId);

  Future<bool> isBlockedEitherWay({
    required String accountId,
    required String otherAccountId,
  });
}

class AccountBlockDatasource implements IAccountBlockDatasource {
  final SupabaseClient client;

  const AccountBlockDatasource(this.client);

  @override
  Future<void> insertBlock({
    required String blockerAccountId,
    required String blockedAccountId,
  }) async {
    try {
      await client.from('account_blocks').insert({
        'blocker_account_id': blockerAccountId,
        'blocked_account_id': blockedAccountId,
      });
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        return;
      }
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }

  @override
  Future<List<String>> listBlockedAccountIds(String blockerAccountId) async {
    try {
      final rows = await client
          .from('account_blocks')
          .select('blocked_account_id')
          .eq('blocker_account_id', blockerAccountId);
      return (rows as List)
          .map((row) => (row as Map)['blocked_account_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }

  @override
  Future<bool> isBlockedEitherWay({
    required String accountId,
    required String otherAccountId,
  }) async {
    try {
      final rows = await client
          .from('account_blocks')
          .select('id')
          .or(
            'and(blocker_account_id.eq.$accountId,blocked_account_id.eq.$otherAccountId),'
            'and(blocker_account_id.eq.$otherAccountId,blocked_account_id.eq.$accountId)',
          )
          .limit(1);
      return (rows as List).isNotEmpty;
    } on PostgrestException catch (error) {
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      if (error is FailureDatasource) rethrow;
      throw FailureDatasource(message: error.toString());
    }
  }
}
