import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../customer/data/models/customer_model.dart';

abstract interface class IMyImmobilesDatasource {
  Future<List<ImmobileCustomerModel>> listOwnedImmobiles(String accountId);

  Future<ImmobileCustomerModel> createOwnedListing(String accountId);
}

class MyImmobilesDatasource implements IMyImmobilesDatasource {
  const MyImmobilesDatasource(this._database);

  final SupabaseDatabaseService _database;

  @override
  Future<List<ImmobileCustomerModel>> listOwnedImmobiles(
    String accountId,
  ) async {
    final rows = await _database.listOwnedImmobiles(accountId);
    return rows
        .map((row) => ImmobileCustomerModel.fromMap(row))
        .toList(growable: false);
  }

  @override
  Future<ImmobileCustomerModel> createOwnedListing(String accountId) async {
    final row = await _database.createOwnedImmobileListing(accountId);
    return ImmobileCustomerModel.fromMap(row);
  }
}
