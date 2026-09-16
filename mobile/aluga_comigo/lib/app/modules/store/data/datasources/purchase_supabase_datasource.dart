import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../customer/data/models/customer_model.dart';

abstract interface class IPurchaseSupabaseDatasource {
  Future<UserInventory> getInventory();
  Future<void> fulfillPurchase({
    required String productId,
    required String transactionId,
    required String platform,
  });
}

class PurchaseSupabaseDatasource implements IPurchaseSupabaseDatasource {
  final SupabaseDatabaseService database;

  const PurchaseSupabaseDatasource(this.database);

  @override
  Future<UserInventory> getInventory() async {
    final map = await database.getUserInventory();
    final inventory = UserInventory.fromMap(map);
    SessionService.setInventory(inventory);
    return inventory;
  }

  @override
  Future<void> fulfillPurchase({
    required String productId,
    required String transactionId,
    required String platform,
  }) async {
    await database.fulfillPurchase(
      productId: productId,
      transactionId: transactionId,
      platform: platform,
    );
    await getInventory();

    if (productId.startsWith('power_up_')) {
      await _refreshProfilePowerUp();
    }
  }

  Future<void> _refreshProfilePowerUp() async {
    final session = SessionService.customer;
    if (session == null) return;

    final response = await database.readProfile(session.id);
    response.fold(
      (_) {},
      (map) {
        if (map.isEmpty) return;
        SessionService.setCustomer(CustomerModel.fromMap(map));
      },
    );
  }
}
