import 'package:aluga_comigo/app/shared/domain/entities/failures.dart';

import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/domain/typedefs/returns.dart';
import '../../../customer/data/models/customer_model.dart';

abstract interface class IProfileDatasource {
  Future<CustomerModel> getProfile(String id);
  Future<void> updateProfile(CustomerModel customer);
}

class ProfileDatasource implements IProfileDatasource {
  final SupabaseDatabaseService _database;

  ProfileDatasource(this._database);

  @override
  Future<CustomerModel> getProfile(String id) async {
    final response = await _database.readProfile(id);

    return response.fold(
      (l) {
        throw FailureDatasource(message: l.message);
      },
      (Json r) {
        if (r.isEmpty) {
          throw FailureDatasource(message: 'Usuário não encontrado');
        }

        return CustomerModel.fromMap(r);
      },
    );
  }

  @override
  Future<void> updateProfile(CustomerModel customer) async {
    final result = await _database.updateProfile(
      customer.id,
      customer.toMap(),
    );

    result.fold(
      (failure) => throw FailureDatasource(message: failure.message),
      (_) {},
    );
  }
}
