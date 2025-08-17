import 'package:aluga_comigo/app/shared/domain/entities/failures.dart';

import '../../../../shared/data/services/firebase_database_service.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/entities/customer.dart';

abstract interface class IProfileDatasource {
  Future<Customer> getProfile(String id);
  Future<void> updateProfile(Customer customer);
}

class ProfileDatasource implements IProfileDatasource {
  final FirebaseDatabaseService _database;

  ProfileDatasource(this._database);

  @override
  Future<Customer> getProfile(String id) async {
    final response = await _database.read(FirebaseDataTables.users, id);

    return response.fold(
      (l) {
        throw FailureDatasource(message: l.message);
      },
      (r) async {
        if (r.isEmpty) {
          throw FailureDatasource(message: "Usuário não encontrado");
        }

        return Customer.fromModel(CustomerModel.fromMap(r));
      },
    );
  }

  @override
  Future<void> updateProfile(Customer customer) async {
    await _database.update(
      FirebaseDataTables.users,
      customer.id,
      customer.toMap(),
    );
  }
}
