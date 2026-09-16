import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/data/services/session_service.dart';
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
  Future<void> purchase(StoreProduct product);
}

class StoreController extends IStoreController {
  final IPurchaseRepository _repository;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  StoreController(this._repository);

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
      } catch (error) {
        errorMessage = error.toString();
        purchaseSuccessMessage = null;
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
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
