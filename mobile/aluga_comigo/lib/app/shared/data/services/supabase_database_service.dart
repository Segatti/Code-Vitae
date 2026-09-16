import 'package:dartz/dartz.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/supabase_error_handler.dart';
import '../../domain/helpers/account_mapper.dart';
import '../../domain/helpers/chat_mapper.dart';
import '../../domain/helpers/immobile_mapper.dart';
import '../../domain/helpers/message_mapper.dart';
import '../../domain/helpers/person_mapper.dart';
import '../../domain/typedefs/returns.dart';

class SupabaseDatabaseService {
  final SupabaseClient _client;

  const SupabaseDatabaseService(this._client);

  Future<Either<FailureDatasource, void>> createAccount(Json data) async {
    try {
      await _client.from('accounts').upsert(AccountMapper.toRow(data));
      return const Right(null);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, Json>> readAccount(String id) async {
    try {
      final data = await _client
          .from('accounts')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (data == null) return const Right({});
      return Right(Map<String, dynamic>.from(data));
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, void>> createPerson(Json data) async {
    try {
      await _client.from('persons').upsert(PersonMapper.toRow(data));
      return const Right(null);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, void>> createImmobile(Json data) async {
    try {
      await _client.from('immobiles').upsert(ImmobileMapper.toRow(data));
      return const Right(null);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, Json>> readPerson(String id) async {
    try {
      final data = await _client
          .from('persons')
          .select('*, accounts(*)')
          .eq('id', id)
          .maybeSingle();
      if (data == null) return const Right({});
      final row = Map<String, dynamic>.from(data);
      return Right(PersonMapper.toAppMap(row));
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, Json>> readImmobile(String id) async {
    try {
      final data = await _client
          .from('immobiles')
          .select('*, accounts(*)')
          .eq('id', id)
          .maybeSingle();
      if (data == null) return const Right({});
      final row = Map<String, dynamic>.from(data);
      return Right(ImmobileMapper.toAppMap(row));
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, Json>> readProfile(String id) async {
    final accountResult = await readAccount(id);
    if (accountResult.isLeft()) {
      return Left(
        accountResult.fold((l) => l, (_) => FailureDatasource(message: '')),
      );
    }

    final account = accountResult.getOrElse(() => <String, dynamic>{});
    if (account.isEmpty) return const Right(<String, dynamic>{});

    final typeUser = account['type_user'] as String?;
    if (typeUser == 'person') return readPerson(id);
    if (typeUser == 'immobile') return readImmobile(id);
    return const Right(<String, dynamic>{});
  }

  Future<Either<FailureDatasource, void>> createProfile(Json data) async {
    final accountResult = await createAccount(data);
    if (accountResult.isLeft()) {
      return Left(
        accountResult.fold((l) => l, (_) => FailureDatasource(message: '')),
      );
    }

    final typeUser = data['typeUser'] as String?;
    if (typeUser == 'person') return createPerson(data);
    if (typeUser == 'immobile') return createImmobile(data);
    return Left(FailureDatasource(message: 'Tipo de usuário inválido'));
  }

  Future<Either<FailureDatasource, void>> updatePerson(String id, Json data) async {
    try {
      await _client.from('persons').update(PersonMapper.toRow(data)).eq('id', id);
      if (data.containsKey('phone') || data.containsKey('email')) {
        await _client.from('accounts').update({
          if (data.containsKey('phone')) 'phone': data['phone'],
          if (data.containsKey('email')) 'email': data['email'],
        }).eq('id', id);
      }
      return const Right(null);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, void>> updateImmobile(
    String id,
    Json data,
  ) async {
    try {
      await _client
          .from('immobiles')
          .update(ImmobileMapper.toRow(data))
          .eq('id', id);
      if (data.containsKey('phone') || data.containsKey('email')) {
        await _client.from('accounts').update({
          if (data.containsKey('phone')) 'phone': data['phone'],
          if (data.containsKey('email')) 'email': data['email'],
        }).eq('id', id);
      }
      return const Right(null);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Either<FailureDatasource, void>> updateProfile(String id, Json data) async {
    final typeUser = data['typeUser'] as String?;
    if (typeUser == 'person') return updatePerson(id, data);
    if (typeUser == 'immobile') return updateImmobile(id, data);
    return Left(FailureDatasource(message: 'Tipo de usuário inválido'));
  }

  Future<List<Json>> listPersons({
    String? excludeId,
    List<String>? excludeIds,
    String? city,
    String? state,
    int limit = 1,
  }) async {
    try {
      var filter = _client
          .from('persons')
          .select('*, accounts!inner(is_active, email, phone, type_user)')
          .eq('accounts.is_active', true);

      if (excludeId != null && excludeId.isNotEmpty) {
        filter = filter.neq('id', excludeId);
      }

      if (excludeIds != null && excludeIds.isNotEmpty) {
        filter = filter.not('id', 'in', excludeIds);
      }

      if (city != null && city.isNotEmpty) {
        filter = filter.ilike('city', city);
      }

      if (state != null && state.isNotEmpty) {
        filter = filter.ilike('state', state);
      }

      final rows = await filter
          .order('power_up_until', ascending: false, nullsFirst: false)
          .order('created_at', ascending: false)
          .limit(limit);
      return rows
          .map((row) => PersonMapper.toAppMap(Map<String, dynamic>.from(row)))
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listImmobiles({
    String? excludeId,
    List<String>? excludeIds,
    String? city,
    String? state,
    int limit = 1,
  }) async {
    try {
      var filter = _client
          .from('immobiles')
          .select('*, accounts!inner(is_active, email, phone, type_user)')
          .eq('accounts.is_active', true);

      if (excludeId != null && excludeId.isNotEmpty) {
        filter = filter.neq('id', excludeId);
      }

      if (excludeIds != null && excludeIds.isNotEmpty) {
        filter = filter.not('id', 'in', excludeIds);
      }

      if (city != null && city.isNotEmpty) {
        filter = filter.ilike('city', city);
      }

      if (state != null && state.isNotEmpty) {
        filter = filter.ilike('state', state);
      }

      final rows = await filter
          .order('power_up_until', ascending: false, nullsFirst: false)
          .order('created_at', ascending: false)
          .limit(limit);
      return rows
          .map((row) => ImmobileMapper.toAppMap(Map<String, dynamic>.from(row)))
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> createPersonPeerMatch({
    required String fromPersonId,
    required String toPersonId,
    required String matchType,
  }) async {
    try {
      await _client.from('person_peer_matches').upsert({
        'from_person_id': fromPersonId,
        'to_person_id': toPersonId,
        'match_type': matchType,
      });
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> createPersonMatch({
    required String personId,
    required String immobileId,
    required String matchType,
  }) async {
    try {
      await _client.from('person_matches').upsert({
        'person_id': personId,
        'immobile_id': immobileId,
        'match_type': matchType,
      });
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> createImmobileMatch({
    required String immobileId,
    required String personId,
    required String matchType,
  }) async {
    try {
      await _client.from('immobile_matches').upsert({
        'immobile_id': immobileId,
        'person_id': personId,
        'match_type': matchType,
      });
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> updateLastMatchPersonPeer(
    String personId,
    String targetPersonId,
  ) async {
    try {
      await _client.from('persons').update({
        'last_match_person_id': targetPersonId,
      }).eq('id', personId);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> updateLastMatchPerson(String personId, String immobileId) async {
    try {
      await _client.from('persons').update({
        'last_match_immobile_id': immobileId,
      }).eq('id', personId);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> updateLastMatchImmobile(
    String immobileId,
    String personId,
  ) async {
    try {
      await _client.from('immobiles').update({
        'last_match_person_id': personId,
      }).eq('id', immobileId);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listIncomingPersonMatches(String immobileId) async {
    try {
      final rows = await _client
          .from('person_matches')
          .select('match_type, persons(*, accounts(*))')
          .eq('immobile_id', immobileId)
          .inFilter('match_type', ['like', 'favorite'])
          .order('created_at', ascending: false);

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final person = map['persons'];
            if (person is! Map) return null;
            final customer = PersonMapper.toAppMap(
              Map<String, dynamic>.from(person),
            );
            if (customer['isActive'] == false) return null;
            return {
              'matchType': map['match_type'] as String? ?? 'none',
              'customer': customer,
            };
          })
          .whereType<Json>()
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listIncomingImmobileMatches(String personId) async {
    try {
      final rows = await _client
          .from('immobile_matches')
          .select('match_type, immobiles(*, accounts(*))')
          .eq('person_id', personId)
          .inFilter('match_type', ['like', 'favorite'])
          .order('created_at', ascending: false);

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final immobile = map['immobiles'];
            if (immobile is! Map) return null;
            final customer = ImmobileMapper.toAppMap(
              Map<String, dynamic>.from(immobile),
            );
            if (customer['isActive'] == false) return null;
            return {
              'matchType': map['match_type'] as String? ?? 'none',
              'customer': customer,
            };
          })
          .whereType<Json>()
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<String>> listPersonPeerMatchedTargetIds(String fromPersonId) async {
    try {
      final rows = await _client
          .from('person_peer_matches')
          .select('to_person_id')
          .eq('from_person_id', fromPersonId);
      return rows
          .map((row) => row['to_person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<String>> listPersonMatchedImmobileIds(String personId) async {
    try {
      final rows = await _client
          .from('person_matches')
          .select('immobile_id')
          .eq('person_id', personId);
      return rows
          .map((row) => row['immobile_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<String>> listImmobileMatchedPersonIds(String immobileId) async {
    try {
      final rows = await _client
          .from('immobile_matches')
          .select('person_id')
          .eq('immobile_id', immobileId);
      return rows
          .map((row) => row['person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listRejectedPeersByPerson(String fromPersonId) async {
    try {
      final rows = await _client
          .from('person_peer_matches')
          .select(
            'match_type, created_at, persons!person_peer_matches_to_person_id_fkey(*)',
          )
          .eq('from_person_id', fromPersonId)
          .inFilter('match_type', ['like', 'favorite', 'unlike'])
          .order('created_at', ascending: false);

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final person = map['persons'];
            if (person is! Map) return null;
            final customer = PersonMapper.toAppMap(
              Map<String, dynamic>.from(person),
            );
            if (customer['isActive'] == false) return null;
            return {
              'customer': customer,
              'matchType': map['match_type'],
              'rejectedAt': map['created_at'],
            };
          })
          .whereType<Json>()
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listRejectedImmobilesByPerson(String personId) async {
    try {
      final rows = await _client
          .from('person_matches')
          .select('match_type, created_at, immobiles(*, accounts(*))')
          .eq('person_id', personId)
          .inFilter('match_type', ['like', 'favorite', 'unlike'])
          .order('created_at', ascending: false);

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final immobile = map['immobiles'];
            if (immobile is! Map) return null;
            final customer = ImmobileMapper.toAppMap(
              Map<String, dynamic>.from(immobile),
            );
            if (customer['isActive'] == false) return null;
            return {
              'customer': customer,
              'matchType': map['match_type'],
              'rejectedAt': map['created_at'],
            };
          })
          .whereType<Json>()
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listRejectedPersonsByImmobile(String immobileId) async {
    try {
      final rows = await _client
          .from('immobile_matches')
          .select('match_type, created_at, persons(*, accounts(*))')
          .eq('immobile_id', immobileId)
          .inFilter('match_type', ['like', 'favorite', 'unlike'])
          .order('created_at', ascending: false);

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final person = map['persons'];
            if (person is! Map) return null;
            final customer = PersonMapper.toAppMap(
              Map<String, dynamic>.from(person),
            );
            if (customer['isActive'] == false) return null;
            return {
              'customer': customer,
              'matchType': map['match_type'],
              'rejectedAt': map['created_at'],
            };
          })
          .whereType<Json>()
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listChatsForUser(String userId) async {
    try {
      final rows = await _client
          .from('chats')
          .select()
          .or('person_id.eq.$userId,immobile_id.eq.$userId')
          .order('last_message_at', ascending: false, nullsFirst: false);

      return rows
          .map(
            (row) => ChatMapper.fromRow(
              Map<String, dynamic>.from(row),
              userId,
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listMessages(String chatId) async {
    try {
      final rows = await _client
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('created_at', ascending: true);

      final userId = _client.auth.currentUser?.id ?? '';
      return rows
          .map(
            (row) => MessageMapper.fromRow(
              Map<String, dynamic>.from(row),
              userId,
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<Json> getUserInventory() async {
    try {
      final result = await _client.rpc('get_user_inventory');
      return Map<String, dynamic>.from(result as Map);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<bool> consumeSuperStar() async {
    try {
      final result = await _client.rpc('consume_super_star');
      return result == true;
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<bool> consumeSuperChat() async {
    try {
      final result = await _client.rpc('consume_super_chat');
      return result == true;
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> fulfillPurchase({
    required String productId,
    required String transactionId,
    required String platform,
  }) async {
    try {
      await _client.rpc(
        'fulfill_purchase',
        params: {
          'p_product_id': productId,
          'p_transaction_id': transactionId,
          'p_platform': platform,
        },
      );
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> setAccountActive(bool active) async {
    try {
      await _client.rpc('set_account_active', params: {'p_active': active});
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> incrementQuestProgress(String actionType) async {
    try {
      await _client.rpc(
        'increment_quest_progress',
        params: {'p_action_type': actionType},
      );
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<Json>> getUserQuests() async {
    try {
      final result = await _client.rpc('get_user_quests');
      final list = result as List<dynamic>? ?? const [];
      return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> claimQuestReward(String questId) async {
    try {
      await _client.rpc('claim_quest_reward', params: {'p_quest_id': questId});
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<Json> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
  }) async {
    try {
      final data = await _client
          .from('messages')
          .insert(
            MessageMapper.toRow(
              chatId: chatId,
              senderId: senderId,
              content: content,
              messageType: messageType,
            ),
          )
          .select()
          .single();

      return MessageMapper.fromRow(
        Map<String, dynamic>.from(data),
        senderId,
      );
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }
}
