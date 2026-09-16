import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

abstract interface class IIapDatasource {
  Stream<List<PurchaseDetails>> get purchaseStream;
  Future<bool> isAvailable();
  Future<List<ProductDetails>> queryProducts(Set<String> productIds);
  Future<bool> buyProduct(ProductDetails product);
  Future<void> completePurchase(PurchaseDetails purchase);
}

class IapDatasource implements IIapDatasource {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async {
    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
    return response.productDetails;
  }

  @override
  Future<bool> buyProduct(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    return _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    return _iap.completePurchase(purchase);
  }
}
