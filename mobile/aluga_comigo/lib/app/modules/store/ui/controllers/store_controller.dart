import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/data/services/analytics_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/domain/analytics/analytics_events.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../interactor/models/store_catalog.dart';
import '../../interactor/models/store_product.dart';

abstract interface class IStoreController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  UserInventory inventory = SessionService.inventory;
  Map<String, ProductDetails> storeProducts = {};
  bool storeAvailable = false;
  String? purchasingProductId;
  String? purchaseSuccessMessage;

  Future<void> initialize();
  String priceFor(StoreProduct product);
  String? compareAtPriceFor(StoreProduct product);
  bool get firstPurchaseOfferEligible;
  Future<void> purchase(StoreProduct product);
  Future<void> restorePurchases();
}

class StoreController extends IStoreController {
  final IPurchaseRepository _repository;
  final IAnalyticsService _analytics;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  StoreController(this._repository, this._analytics);

  @override
  Future<void> initialize() async {
    loadingList.add('initialize');
    notifyListeners();

    _purchaseSubscription ??= _repository.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (error) {
        errorMessage = error.toString();
        purchasingProductId = null;
        notifyListeners();
      },
    );

    try {
      storeAvailable = await _repository.isStoreAvailable();
      inventory = await _repository.loadInventory();

      if (storeAvailable) {
        final ids = StoreCatalog.allProductIds.toSet();
        storeProducts = await _repository.loadStoreProducts(ids);
      }
      errorMessage = '';
    } catch (error) {
      errorMessage = 'Erro ao carregar loja';
    } finally {
      loadingList.remove('initialize');
      notifyListeners();
    }
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      try {
        await _repository.handlePurchaseUpdate(purchase);
        inventory = SessionService.inventory;
        errorMessage = '';
        purchaseSuccessMessage = 'Compra realizada com sucesso!';
        await _analytics.logEvent(
          AnalyticsEvents.purchase,
          parameters: {
            AnalyticsParams.itemId: purchase.productID,
            AnalyticsParams.transactionId: purchase.purchaseID ?? '',
          },
        );
      } catch (error) {
        await _analytics.logEvent(
          AnalyticsEvents.purchaseFailed,
          parameters: {
            AnalyticsParams.itemId: purchase.productID,
            AnalyticsParams.errorMessage: error.toString(),
          },
        );
        final raw = error.toString();
        if (raw.contains('first purchase offer not eligible')) {
          errorMessage =
              'Esta oferta é exclusiva para quem nunca comprou na loja.';
        } else {
          errorMessage = raw;
        }
        purchaseSuccessMessage = null;
        try {
          inventory = await _repository.loadInventory();
        } catch (_) {}
      } finally {
        purchasingProductId = null;
        notifyListeners();
      }
    }
  }

  @override
  String priceFor(StoreProduct product) {
    final details = storeProducts[product.id];
    if (details != null) return details.price;
    return product.priceLabel;
  }

  @override
  String? compareAtPriceFor(StoreProduct product) {
    if (product.compareAtPriceLabel == null) return null;
    return product.compareAtPriceLabel;
  }

  @override
  bool get firstPurchaseOfferEligible =>
      inventory.firstPurchaseOfferEligible;

  @override
  Future<void> purchase(StoreProduct product) async {
    if (purchasingProductId != null) return;

    final details = storeProducts[product.id];
    if (!storeAvailable || details == null) {
      errorMessage =
          'Loja indisponível. Configure os produtos na Google Play ou App Store.';
      notifyListeners();
      return;
    }

    purchasingProductId = product.id;
    errorMessage = '';
    notifyListeners();

    try {
      await _analytics.logEvent(
        AnalyticsEvents.beginCheckout,
        parameters: {
          AnalyticsParams.itemId: product.id,
          AnalyticsParams.itemCategory: product.category.name,
        },
      );
      final started = await _repository.startPurchase(details);
      if (!started) {
        purchasingProductId = null;
        errorMessage = 'Não foi possível iniciar a compra';
        notifyListeners();
      }
    } catch (error) {
      purchasingProductId = null;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  @override
  Future<void> restorePurchases() async {
    if (!storeAvailable) {
      errorMessage = 'Loja indisponível.';
      notifyListeners();
      return;
    }
    loadingList.add('restore');
    notifyListeners();
    try {
      await _analytics.logEvent(AnalyticsEvents.restorePurchases);
      await _repository.restorePurchases();
      errorMessage = '';
      purchaseSuccessMessage =
          'Restauração solicitada. Créditos pendentes serão aplicados '
          'quando a loja confirmar.';
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      loadingList.remove('restore');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
