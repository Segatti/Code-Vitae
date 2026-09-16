import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../shared/data/services/session_service.dart';
import '../datasources/iap_datasource.dart';
import '../datasources/purchase_supabase_datasource.dart';

abstract interface class IPurchaseRepository {
  Stream<List<PurchaseDetails>> get purchaseStream;
  Future<bool> isStoreAvailable();
  Future<Map<String, ProductDetails>> loadStoreProducts(Set<String> productIds);
  Future<UserInventory> loadInventory();
  Future<bool> startPurchase(ProductDetails product);
  Future<void> handlePurchaseUpdate(PurchaseDetails purchase);
}

class PurchaseRepository implements IPurchaseRepository {
  final IIapDatasource iap;
  final IPurchaseSupabaseDatasource supabase;

  PurchaseRepository(this.iap, this.supabase);

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => iap.purchaseStream;

  @override
  Future<bool> isStoreAvailable() => iap.isAvailable();

  @override
  Future<Map<String, ProductDetails>> loadStoreProducts(
    Set<String> productIds,
  ) async {
    final products = await iap.queryProducts(productIds);
    return {for (final product in products) product.id: product};
  }

  @override
  Future<UserInventory> loadInventory() => supabase.getInventory();

  @override
  Future<bool> startPurchase(ProductDetails product) {
    return iap.buyProduct(product);
  }

  @override
  Future<void> handlePurchaseUpdate(PurchaseDetails purchase) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        return;
      case PurchaseStatus.error:
        throw Exception(purchase.error?.message ?? 'Erro na compra');
      case PurchaseStatus.canceled:
        return;
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        break;
    }

    final transactionId = purchase.purchaseID;
    if (transactionId == null || transactionId.isEmpty) {
      throw Exception('Transação inválida');
    }

    final platform = Platform.isIOS ? 'apple' : 'google';

    await supabase.fulfillPurchase(
      productId: purchase.productID,
      transactionId: transactionId,
      platform: platform,
    );

    if (purchase.pendingCompletePurchase) {
      await iap.completePurchase(purchase);
    }
  }
}
