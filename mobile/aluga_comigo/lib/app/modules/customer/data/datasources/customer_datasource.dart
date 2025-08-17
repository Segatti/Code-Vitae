import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/customer.dart';
import '../../domain/enums/match_type.dart';
import '../models/customer_model.dart';

abstract interface class ICustomerDatasource {
  Future<List<Customer>> getCustomers({String? startAfter});
  Future<Unit> matchCustomer(Customer customer, MatchType matchType);
}

class CustomerDatasource implements ICustomerDatasource {
  final FirebaseDatabaseService database;
  final SecureStorageService storage;

  const CustomerDatasource(this.database, this.storage);

  @override
  Future<Unit> matchCustomer(Customer customer, MatchType matchType) async {
    await database
        .getRef(FirebaseDataTables.users)
        .doc(SessionService.user!.id)
        .collection(FirebaseDataTables.matchTo.name)
        .doc(customer.id)
        .set({...customer.toMap(), 'matchType': matchType.name});

    await database
        .getRef(FirebaseDataTables.users)
        .doc(SessionService.user!.id)
        .set({
          'lastMatch': customer.id,
        });

    final json = await storage.getData(StorageKey.user);
    final user = UserModel.fromJson(json!);
    final newUser = user.copyWith(lastMatch: customer.id);
    await storage.setData(StorageKey.user, newUser.toJson());
    SessionService.user = User.fromModel(newUser);

    return unit;
  }

  @override
  Future<List<Customer>> getCustomers({String? startAfter}) async {
    var query = database
        .getRef(FirebaseDataTables.users)
        // .where('typeUser', isEqualTo: TypeUser.person.name)
        .where('isActive', isEqualTo: true)
        .orderBy('id', descending: true)
        .limit(1);

    if (startAfter != null) {
      query = query.startAfter([startAfter]);
    }

    final data = await query.get();
    if (startAfter != null && data.docs.isNotEmpty) {
      final idLastMatch = data.docs.last.id;
      await database.update(FirebaseDataTables.users, SessionService.user!.id, {
        'lastMatch': idLastMatch,
      });
    }

    return data.docs
        .map(
          (e) => Customer.fromModel(
            CustomerModel.fromMap({'id': e.id, ...e.data()}),
          ),
        )
        .toList();
  }
}
