import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/entities/failures.dart';
import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../domain/enums/match_type.dart';
import '../models/customer_model.dart';

abstract interface class ICustomerDatasource {
  Future<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    String? startAfter,
  });
  Future<Unit> matchCustomer(CustomerModel customer, MatchType matchType);
}

class CustomerDatasource implements ICustomerDatasource {
  final SupabaseDatabaseService database;
  final SecureStorageService storage;

  const CustomerDatasource(this.database, this.storage);

  @override
  Future<Unit> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    final session = SessionService.customer!;
    final sessionId = session.id;

    if (matchType == MatchType.favorite) {
      final consumed = await database.consumeSuperStar();
      if (!consumed) {
        throw FailureDatasource(
          message: 'Você não tem Super Star. Compre na loja.',
        );
      }
    }

    switch (session.typeUser) {
      case TypeUser.person:
        if (customer.typeUser != TypeUser.immobile) {
          throw FailureDatasource(
            message: 'Match inválido: inquilino só pode combinar com imóveis.',
          );
        }
        await database.createPersonMatch(
          personId: sessionId,
          immobileId: customer.id,
          matchType: matchType.name,
        );
        await database.updateLastMatchPerson(sessionId, customer.id);
      case TypeUser.immobile:
        if (customer.typeUser != TypeUser.person) {
          throw FailureDatasource(
            message: 'Match inválido: imóvel só pode combinar com inquilinos.',
          );
        }
        await database.createImmobileMatch(
          immobileId: sessionId,
          personId: customer.id,
          matchType: matchType.name,
        );
        await database.updateLastMatchImmobile(sessionId, customer.id);
      case TypeUser.none:
        break;
    }

    final json = await storage.getData(StorageKey.user);
    final user = UserModel.fromJson(json!);
    final newUser = user.copyWith(lastMatch: customer.id);
    await storage.setData(StorageKey.user, newUser.toJson());

    switch (session) {
      case PersonCustomerModel():
        SessionService.setCustomer(session.copyWith(lastMatch: customer.id));
      case ImmobileCustomerModel():
        SessionService.setCustomer(session.copyWith(lastMatch: customer.id));
    }

    if (matchType == MatchType.like || matchType == MatchType.favorite) {
      await database.incrementQuestProgress(matchType.name);
    }

    return unit;
  }

  ({String city, String state}) _locationFromSession(CustomerModel session) {
    final parts = session.cityState.split(' - ');
    return (
      city: parts.isNotEmpty ? parts.first.trim() : '',
      state: parts.length > 1 ? parts[1].trim() : '',
    );
  }

  @override
  Future<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    String? startAfter,
  }) async {
    final session = SessionService.customer!;
    final excludeId = session.id;
    final location = _locationFromSession(session);

    if (location.city.isEmpty) {
      return [];
    }

    final matchedIds = switch (session.typeUser) {
      TypeUser.person => await database.listPersonMatchedImmobileIds(session.id),
      TypeUser.immobile =>
        await database.listImmobileMatchedPersonIds(session.id),
      TypeUser.none => <String>[],
    };

    final rows = switch (typeUser) {
      TypeUser.person => await database.listPersons(
          startAfter: startAfter,
          excludeId: excludeId,
          excludeIds: matchedIds,
          city: location.city,
          state: location.state,
          limit: 1,
        ),
      TypeUser.immobile => await database.listImmobiles(
          startAfter: startAfter,
          excludeId: excludeId,
          excludeIds: matchedIds,
          city: location.city,
          state: location.state,
          limit: 1,
        ),
      TypeUser.none => <Map<String, dynamic>>[],
    };

    if (startAfter != null && rows.isNotEmpty) {
      final idLast = rows.last['id'] as String;
      switch ((session.typeUser, typeUser)) {
        case (TypeUser.person, TypeUser.immobile):
          await database.updateLastMatchPerson(session.id, idLast);
        case (TypeUser.immobile, TypeUser.person):
          await database.updateLastMatchImmobile(session.id, idLast);
        default:
          break;
      }
    }

    return rows
        .map<CustomerModel>((row) => CustomerModel.fromMap(row))
        .toList();
  }
}
