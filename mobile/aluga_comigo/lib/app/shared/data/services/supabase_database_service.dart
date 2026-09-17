import 'package:dartz/dartz.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/supabase_error_handler.dart';
import '../../domain/helpers/account_mapper.dart';
import '../../domain/helpers/chat_mapper.dart';
import '../../domain/helpers/peer_chat_mapper.dart';
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

  static bool _isPositiveMatchType(String? type) {
    return type == 'like' || type == 'favorite';
  }

  static bool _pendingIncomingAfterMyAction(String? myMatchType) {
    if (myMatchType == null || myMatchType == 'none') return true;
    return false;
  }

  Future<bool> hasMutualPersonPeerMatch({
    required String personId,
    required String otherPersonId,
  }) async {
    try {
      final rows = await _client
          .from('person_peer_matches')
          .select('from_person_id, match_type')
          .or(
            'and(from_person_id.eq.$personId,to_person_id.eq.$otherPersonId),'
            'and(from_person_id.eq.$otherPersonId,to_person_id.eq.$personId)',
          );

      var selfPositive = false;
      var otherPositive = false;
      for (final row in rows) {
        final map = Map<String, dynamic>.from(row);
        final from = map['from_person_id']?.toString() ?? '';
        final type = map['match_type']?.toString();
        if (from == personId) {
          selfPositive = _isPositiveMatchType(type);
        } else if (from == otherPersonId) {
          otherPositive = _isPositiveMatchType(type);
        }
      }
      return selfPositive && otherPositive;
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<bool> hasMutualPersonImmobileMatch({
    required String personId,
    required String immobileId,
  }) async {
    try {
      final personRow = await _client
          .from('person_matches')
          .select('match_type')
          .eq('person_id', personId)
          .eq('immobile_id', immobileId)
          .maybeSingle();

      final immobileRow = await _client
          .from('immobile_matches')
          .select('match_type')
          .eq('immobile_id', immobileId)
          .eq('person_id', personId)
          .maybeSingle();

      return _isPositiveMatchType(personRow?['match_type']?.toString()) &&
          _isPositiveMatchType(immobileRow?['match_type']?.toString());
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
      await _client.from('person_peer_matches').upsert(
        {
          'from_person_id': fromPersonId,
          'to_person_id': toPersonId,
          'match_type': matchType,
        },
        onConflict: 'from_person_id,to_person_id',
      );
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
      await _client.from('person_matches').upsert(
        {
          'person_id': personId,
          'immobile_id': immobileId,
          'match_type': matchType,
        },
        onConflict: 'person_id,immobile_id',
      );
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
      await _client.from('immobile_matches').upsert(
        {
          'immobile_id': immobileId,
          'person_id': personId,
          'match_type': matchType,
        },
        onConflict: 'immobile_id,person_id',
      );
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
          .select('match_type, person_id, persons(*, accounts(*))')
          .eq('immobile_id', immobileId)
          .inFilter('match_type', ['like', 'favorite'])
          .order('created_at', ascending: false);

      if (rows.isEmpty) return [];

      final personIds = rows
          .map((row) => row['person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final myRows = await _client
          .from('immobile_matches')
          .select('person_id, match_type')
          .eq('immobile_id', immobileId)
          .inFilter('person_id', personIds);

      final myMatchByPersonId = {
        for (final row in myRows)
          row['person_id']?.toString() ?? '': row['match_type']?.toString(),
      };

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final personId = map['person_id']?.toString() ?? '';
            if (!_pendingIncomingAfterMyAction(myMatchByPersonId[personId])) {
              return null;
            }
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

  /// Pessoas que curtiram/super-stararam [personId] e ainda não há match mútuo.
  Future<List<Json>> listIncomingPersonPeerMatches(String personId) async {
    try {
      final rows = await _client
          .from('person_peer_matches')
          .select(
            'match_type, from_person_id, '
            'persons!person_peer_matches_from_person_id_fkey(*, accounts(*))',
          )
          .eq('to_person_id', personId)
          .inFilter('match_type', ['like', 'favorite'])
          .order('created_at', ascending: false);

      if (rows.isEmpty) return [];

      final fromIds = rows
          .map((row) => row['from_person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final myRows = await _client
          .from('person_peer_matches')
          .select('to_person_id, match_type')
          .eq('from_person_id', personId)
          .inFilter('to_person_id', fromIds);

      final myMatchByPersonId = {
        for (final row in myRows)
          row['to_person_id']?.toString() ?? '': row['match_type']?.toString(),
      };

      return rows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final fromId = map['from_person_id']?.toString() ?? '';
            if (!_pendingIncomingAfterMyAction(myMatchByPersonId[fromId])) {
              return null;
            }
            final person = map['persons'];
            if (person is! Map) return null;
            final customer = PersonMapper.toAppMap(
              Map<String, dynamic>.from(person),
            );
            if (customer['isActive'] == false) return null;
            return {
              'matchType': map['match_type'] as String? ?? 'like',
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

      final immobileChats = rows
          .map(
            (row) => ChatMapper.fromRow(
              Map<String, dynamic>.from(row),
              userId,
            ),
          )
          .toList();

      final peerRows = await _client
          .from('person_peer_chats')
          .select()
          .or('person_low_id.eq.$userId,person_high_id.eq.$userId')
          .order('last_message_at', ascending: false, nullsFirst: false);

      final peerChats = peerRows
          .map(
            (row) => PeerChatMapper.fromRow(
              Map<String, dynamic>.from(row),
              userId,
            ),
          )
          .toList();

      final merged = [...immobileChats, ...peerChats];
      merged.sort((a, b) {
        final aAt = a['lastMessageAt'];
        final bAt = b['lastMessageAt'];
        final aDate = aAt == null
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : DateTime.tryParse(aAt.toString()) ??
                DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = bAt == null
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : DateTime.tryParse(bAt.toString()) ??
                DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return merged;
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listMessages(
    String chatId, {
    bool personPeerChat = false,
  }) async {
    try {
      final table = personPeerChat ? 'person_peer_messages' : 'messages';
      final rows = await _client
          .from(table)
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

  Future<List<Json>> listUserNotifications(String accountId) async {
    try {
      final rows = await _client
          .from('user_notifications')
          .select()
          .eq('account_id', accountId)
          .order('created_at', ascending: false)
          .limit(100);

      return rows
          .map(
            (row) => {
              'id': row['id'],
              'notificationType': row['notification_type'],
              'title': row['title'],
              'body': row['body'],
              'createdAt': row['created_at'],
            },
          )
          .map((map) => Map<String, dynamic>.from(map))
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<Json> getOrCreatePersonImmobileChat({
    required String personId,
    required String immobileId,
  }) async {
    try {
      final row = await _client.rpc(
        'get_or_create_person_immobile_chat',
        params: {
          'p_person_id': personId,
          'p_immobile_id': immobileId,
        },
      );
      return Map<String, dynamic>.from(row as Map);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<Json> getOrCreatePersonPeerChat({
    required String otherPersonId,
  }) async {
    try {
      final row = await _client.rpc(
        'get_or_create_person_peer_chat',
        params: {'p_other_person_id': otherPersonId},
      );
      return Map<String, dynamic>.from(row as Map);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<Json?> findChatByParticipants({
    required String personId,
    required String immobileId,
  }) async {
    try {
      final row = await _client
          .from('chats')
          .select()
          .eq('person_id', personId)
          .eq('immobile_id', immobileId)
          .maybeSingle();
      if (row == null) return null;
      return Map<String, dynamic>.from(row);
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> markChatMessagesRead(String chatId) async {
    try {
      await _client.rpc(
        'mark_chat_messages_read',
        params: {'p_chat_id': chatId},
      );
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<List<Json>> listOutgoingPersonImmobileMatches(String personId) async {
    try {
      final rows = await _client
          .from('person_matches')
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
              'matchType': map['match_type'],
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

  Future<List<Json>> listMutualPersonContactsForImmobile(
    String immobileId,
  ) async {
    try {
      final immobileRows = await _client
          .from('immobile_matches')
          .select('person_id')
          .eq('immobile_id', immobileId)
          .inFilter('match_type', ['like', 'favorite']);

      final personIds = immobileRows
          .map((row) => row['person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (personIds.isEmpty) return [];

      final personRows = await _client
          .from('person_matches')
          .select('match_type, persons(*, accounts(*))')
          .eq('immobile_id', immobileId)
          .inFilter('person_id', personIds)
          .inFilter('match_type', ['like', 'favorite']);

      return personRows
          .map((row) {
            final map = Map<String, dynamic>.from(row);
            final person = map['persons'];
            if (person is! Map) return null;
            final customer = PersonMapper.toAppMap(
              Map<String, dynamic>.from(person),
            );
            if (customer['isActive'] == false) return null;
            return {
              'matchType': map['match_type'],
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

  Future<List<Json>> listMutualPeerPersonContacts(String personId) async {
    try {
      final outgoing = await _client
          .from('person_peer_matches')
          .select('to_person_id, match_type')
          .eq('from_person_id', personId)
          .inFilter('match_type', ['like', 'favorite']);

      if (outgoing.isEmpty) return [];

      final targetIds = outgoing
          .map((row) => row['to_person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      final incoming = await _client
          .from('person_peer_matches')
          .select('from_person_id')
          .eq('to_person_id', personId)
          .inFilter('from_person_id', targetIds)
          .inFilter('match_type', ['like', 'favorite']);

      final mutualIds = incoming
          .map((row) => row['from_person_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      if (mutualIds.isEmpty) return [];

      final persons = await _client
          .from('persons')
          .select('*, accounts(*)')
          .inFilter('id', mutualIds.toList());

      final matchTypeByPersonId = {
        for (final row in outgoing)
          row['to_person_id']?.toString() ?? '': row['match_type']?.toString(),
      };

      return persons
          .map((row) {
            final customer = PersonMapper.toAppMap(
              Map<String, dynamic>.from(row),
            );
            if (customer['isActive'] == false) return null;
            final personId = customer['id']?.toString() ?? '';
            return {
              'matchType': matchTypeByPersonId[personId] ?? 'like',
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

  Future<Json> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
    bool personPeerChat = false,
  }) async {
    try {
      final table = personPeerChat ? 'person_peer_messages' : 'messages';
      final data = await _client
          .from(table)
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

  Future<int> countUserNotificationsAfter({
    required String accountId,
    required DateTime after,
  }) async {
    try {
      final rows = await _client
          .from('user_notifications')
          .select('id')
          .eq('account_id', accountId)
          .gt('created_at', after.toUtc().toIso8601String());

      return rows.length;
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }

  Future<void> deleteChatForUser({
    required String chatId,
    required bool isPersonPeerChat,
  }) async {
    try {
      await _client.rpc(
        'delete_chat_for_user',
        params: {
          'p_chat_id': chatId,
          'p_is_person_peer_chat': isPersonPeerChat,
        },
      );
    } on PostgrestException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    }
  }
}
