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
  final String description;
  final StoreProductIcon icon;
  final Duration boostDuration;
  final String? badgeLabel;
  final bool isRecommended;
  final String? compareAtPriceLabel;

  const StoreProduct({
    required this.id,
    required this.category,
    required this.label,
    required this.priceLabel,
    required this.description,
    required this.icon,
    required this.boostDuration,
    this.badgeLabel,
    this.isRecommended = false,
    this.compareAtPriceLabel,
  });
}
