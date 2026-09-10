import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

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

    switch (session.typeUser) {
      case TypeUser.person:
        await database.createPersonMatch(
          personId: sessionId,
          immobileId: customer.id,
          matchType: matchType.name,
        );
        await database.updateLastMatchPerson(sessionId, customer.id);
      case TypeUser.immobile:
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

    return unit;
  }

  @override
  Future<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    String? startAfter,
  }) async {
    final rows = switch (typeUser) {
      TypeUser.person => await database.listPersons(
          startAfter: startAfter,
          limit: 1,
        ),
      TypeUser.immobile => await database.listImmobiles(
          startAfter: startAfter,
          limit: 1,
        ),
      TypeUser.none => <Map<String, dynamic>>[],
    };

    final session = SessionService.customer!;
    if (startAfter != null && rows.isNotEmpty) {
      final idLast = rows.last['id'] as String;
      switch (session.typeUser) {
        case TypeUser.person:
          await database.updateLastMatchPerson(session.id, idLast);
        case TypeUser.immobile:
          await database.updateLastMatchImmobile(session.id, idLast);
        case TypeUser.none:
          break;
      }
    }

    return rows
        .map<CustomerModel>((row) => CustomerModel.fromMap(row))
        .toList();
  }
}
