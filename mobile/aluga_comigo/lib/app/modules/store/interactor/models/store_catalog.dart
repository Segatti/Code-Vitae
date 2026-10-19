import '../enums/store_item_category.dart';
import 'store_product.dart';

class StoreCatalog {
  static const firstPurchaseOffer = StoreProduct(
    id: 'first_purchase_offer',
    category: StoreItemCategory.powerUp,
    label: 'Pacote boas-vindas',
    priceLabel: 'R\$ 49,99',
    compareAtPriceLabel: 'R\$ 80,99',
    description:
        '7 dias de PowerUp + 5 Super Star + 5 Super Chat — só na primeira compra.',
    icon: StoreProductIcon.powerUp3,
    boostDuration: Duration(days: 7),
    badgeLabel: 'Oferta especial',
  );

  static const superStarProducts = [
    StoreProduct(
      id: 'super_star_1',
      category: StoreItemCategory.superStar,
      label: '2 créditos',
      priceLabel: 'R\$ 11,99',
      description: 'Para experimentar o destaque',
      icon: StoreProductIcon.superStar1,
      boostDuration: Duration.zero,
    ),
    StoreProduct(
      id: 'super_star_2',
      category: StoreItemCategory.superStar,
      label: '5 créditos',
      priceLabel: 'R\$ 27,99',
      description: 'Melhor equilíbrio preço × uso',
      icon: StoreProductIcon.superStar2,
      boostDuration: Duration.zero,
      badgeLabel: 'Popular',
      isRecommended: true,
    ),
    StoreProduct(
      id: 'super_star_3',
      category: StoreItemCategory.superStar,
      label: '10 créditos',
      priceLabel: 'R\$ 49,99',
      description: 'Para quem reage com frequência',
      icon: StoreProductIcon.superStar3,
      boostDuration: Duration.zero,
      badgeLabel: 'Melhor valor',
    ),
  ];

  static const superChatProducts = [
    StoreProduct(
      id: 'super_chat_1',
      category: StoreItemCategory.superChat,
      label: '2 créditos',
      priceLabel: 'R\$ 11,99',
      description: 'Ideal para testar conversas',
      icon: StoreProductIcon.superChat1,
      boostDuration: Duration.zero,
    ),
    StoreProduct(
      id: 'super_chat_2',
      category: StoreItemCategory.superChat,
      label: '5 créditos',
      priceLabel: 'R\$ 27,99',
      description: 'Mais mensagens em destaque',
      icon: StoreProductIcon.superChat2,
      boostDuration: Duration.zero,
      badgeLabel: 'Popular',
      isRecommended: true,
    ),
    StoreProduct(
      id: 'super_chat_3',
      category: StoreItemCategory.superChat,
      label: '10 créditos',
      priceLabel: 'R\$ 49,99',
      description: 'Para conversar sem limites',
      icon: StoreProductIcon.superChat3,
      boostDuration: Duration.zero,
      badgeLabel: 'Melhor valor',
    ),
  ];

  static const powerUpProducts = [
    StoreProduct(
      id: 'power_up_24h',
      category: StoreItemCategory.powerUp,
      label: '24 horas',
      priceLabel: 'R\$ 9,99',
      description: 'Impulso rápido no feed',
      icon: StoreProductIcon.powerUp1,
      boostDuration: Duration(hours: 24),
    ),
    StoreProduct(
      id: 'power_up_7d',
      category: StoreItemCategory.powerUp,
      label: '7 dias',
      priceLabel: 'R\$ 24,99',
      description: '+ 1 Super Star e 1 Super Chat',
      icon: StoreProductIcon.powerUp2,
      boostDuration: Duration(days: 7),
      badgeLabel: 'Popular',
      isRecommended: true,
    ),
    StoreProduct(
      id: 'power_up_30d',
      category: StoreItemCategory.powerUp,
      label: '30 dias',
      priceLabel: 'R\$ 59,99',
      description: '+ 4 Super Stars e 4 Super Chats',
      icon: StoreProductIcon.powerUp3,
      boostDuration: Duration(days: 30),
      badgeLabel: 'Melhor valor',
    ),
  ];

  static List<StoreProduct> productsFor(StoreItemCategory category) =>
      switch (category) {
        StoreItemCategory.superStar => superStarProducts,
        StoreItemCategory.superChat => superChatProducts,
        StoreItemCategory.powerUp => powerUpProducts,
      };

  static List<StoreProduct> get allProducts => [
    firstPurchaseOffer,
    ...powerUpProducts,
    ...superStarProducts,
    ...superChatProducts,
  ];

  static const powerUpProductIds = {
    'power_up_24h',
    'power_up_7d',
    'power_up_30d',
    'first_purchase_offer',
  };

  static List<String> get allProductIds =>
      allProducts.map((product) => product.id).toList();
}
