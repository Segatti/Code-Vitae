import '../enums/store_item_category.dart';

enum StoreProductIcon {
  superStar1,
  superStar2,
  superStar3,
  superChat1,
  superChat2,
  superChat3,
  powerUp1,
  powerUp2,
  powerUp3,
}

class StoreProduct {
  final String id;
  final StoreItemCategory category;
  final String label;
  final String priceLabel;
  final StoreProductIcon icon;
  final Duration boostDuration;

  const StoreProduct({
    required this.id,
    required this.category,
    required this.label,
    required this.priceLabel,
    required this.icon,
    required this.boostDuration,
  });
}
