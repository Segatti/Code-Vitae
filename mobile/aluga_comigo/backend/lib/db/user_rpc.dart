import 'dart:convert';

import 'package:postgres/postgres.dart';

import 'postgres_pool.dart';

/// Executa RPCs Supabase que dependem de [auth.uid()] definindo o claim JWT na sessão.
class UserRpc {
  UserRpc(this._pool);

  final PostgresPool _pool;

  Future<T> runAsUser<T>(
    String userId,
    Future<T> Function(Session session) action,
  ) async {
    final pg = await _pool.client;
    return pg.runTx((session) async {
      await session.execute(
        Sql.named(
          "SELECT set_config('request.jwt.claim.sub', @uid, true)",
        ),
        parameters: {'uid': userId},
      );
      await session.execute(
        Sql.named(
          "SELECT set_config('request.jwt.claim.role', 'authenticated', true)",
        ),
      );
      return action(session);
    });
  }

  Future<Map<String, dynamic>> getUserInventory(String userId) async {
    return runAsUser(userId, (session) async {
      final rows = await session.execute(
        'SELECT public.get_user_inventory()',
      );
      final value = rows.first.first;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      if (value is String) {
        return Map<String, dynamic>.from(jsonDecode(value) as Map);
      }
      throw StateError('unexpected inventory payload');
    });
  }

  Future<bool> consumeSuperStar(String userId) async {
    return runAsUser(userId, (session) async {
      final rows = await session.execute(
        'SELECT public.consume_super_star()',
      );
      return rows.first.first == true;
    });
  }

  Future<bool> consumeSuperChat(String userId) async {
    return runAsUser(userId, (session) async {
      final rows = await session.execute(
        'SELECT public.consume_super_chat()',
      );
      return rows.first.first == true;
    });
  }

  Future<Map<String, dynamic>> fulfillPurchase({
    required String userId,
    required String productId,
    required String transactionId,
    required String platform,
  }) async {
    return runAsUser(userId, (session) async {
      final rows = await session.execute(
        Sql.named(
          'SELECT public.fulfill_purchase(@productId, @transactionId, @platform)',
        ),
        parameters: {
          'productId': productId,
          'transactionId': transactionId,
          'platform': platform,
        },
      );
      final value = rows.first.first;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      if (value is String) {
        return Map<String, dynamic>.from(jsonDecode(value) as Map);
      }
      return {'ok': true};
    });
  }

  Future<void> setAccountActive(String userId, bool active) async {
    await runAsUser(userId, (session) async {
      await session.execute(
        Sql.named('SELECT public.set_account_active(@active)'),
        parameters: {'active': active},
      );
    });
  }

  Future<void> incrementQuestProgress(String userId, String actionType) async {
    await runAsUser(userId, (session) async {
      await session.execute(
        Sql.named('SELECT public.increment_quest_progress(@actionType)'),
        parameters: {'actionType': actionType},
      );
    });
  }

  Future<List<Map<String, dynamic>>> getUserQuests(String userId) async {
    return runAsUser(userId, (session) async {
      final rows = await session.execute('SELECT public.get_user_quests()');
      final value = rows.first.first;
      final List<dynamic> list;
      if (value is List) {
        list = value;
      } else if (value is String) {
        list = jsonDecode(value) as List<dynamic>;
      } else {
        list = const [];
      }
      return list
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    });
  }

  Future<Map<String, dynamic>> claimQuestReward(
    String userId,
    String questId,
  ) async {
    return runAsUser(userId, (session) async {
      final rows = await session.execute(
        Sql.named('SELECT public.claim_quest_reward(@questId)'),
        parameters: {'questId': questId},
      );
      final value = rows.first.first;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      if (value is String) {
        return Map<String, dynamic>.from(jsonDecode(value) as Map);
      }
      return {'ok': true};
    });
  }
}
