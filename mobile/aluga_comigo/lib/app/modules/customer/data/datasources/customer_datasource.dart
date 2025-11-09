import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../../shared/data/services/secure_storage_service.dart';
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
  final FirebaseDatabaseService database;
  final SecureStorageService storage;

  const CustomerDatasource(this.database, this.storage);

  @override
  Future<Unit> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    await database
        .getRef(
          customer.typeUser == TypeUser.person
              ? FirebaseDataTables.users
              : FirebaseDataTables.immobiles,
        )
        .doc(SessionService.customer!.id)
        .collection(FirebaseDataTables.matchTo.name)
        .doc(customer.id)
        .set({
          ...customer.toMap(),
          'matchType': matchType.name,
        }, SetOptions(merge: true));

    await database
        .getRef(
          customer.typeUser == TypeUser.person
              ? FirebaseDataTables.users
              : FirebaseDataTables.immobiles,
        )
        .doc(SessionService.customer!.id)
        .set({'lastMatch': customer.id}, SetOptions(merge: true));

    final json = await storage.getData(StorageKey.user);
    final user = UserModel.fromJson(json!);
    final newUser = user.copyWith(lastMatch: customer.id);
    await storage.setData(StorageKey.user, newUser.toJson());
    var customerData = SessionService.customer!;
    switch (customerData) {
      case PersonCustomerModel():
        SessionService.setCustomer(
          customerData.copyWith(lastMatch: customer.id),
        );
      case ImmobileCustomerModel():
        SessionService.setCustomer(
          customerData.copyWith(lastMatch: customer.id),
        );
    }

    return unit;
  }

  @override
  Future<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    String? startAfter,
  }) async {
    var query = database
        .getRef(
          typeUser == TypeUser.person
              ? FirebaseDataTables.users
              : FirebaseDataTables.immobiles,
        )
        .where('isActive', isEqualTo: true)
        .orderBy('id', descending: true)
        .limit(1);

    if (startAfter != null) {
      query = query.startAfter([startAfter]);
    }

    final data = await query.get();
    if (startAfter != null && data.docs.isNotEmpty) {
      final idLastMatch = data.docs.last.id;
      await database.update(
        FirebaseDataTables.users,
        SessionService.customer!.id,
        {'lastMatch': idLastMatch},
      );
    }

    return data.docs
        .map((e) => CustomerModel.fromMap({'id': e.id, ...e.data()}))
        .toList();
  }
}
