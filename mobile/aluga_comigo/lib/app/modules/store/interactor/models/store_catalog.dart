import '../enums/store_item_category.dart';
import 'store_product.dart';

class StoreCatalog {
  static const superStarProducts = [
    StoreProduct(
      id: 'super_star_1',
      category: StoreItemCategory.superStar,
      label: '1 un.',
      priceLabel: 'R\$ 11,99',
      description:
          '1 crédito de Super Star para usar quando quiser em um perfil ou imóvel.',
      icon: StoreProductIcon.superStar1,
      boostDuration: Duration.zero,
    ),
    StoreProduct(
      id: 'super_star_2',
      category: StoreItemCategory.superStar,
      label: '3 un.',
      priceLabel: 'R\$ 27,99',
      description:
          'Pacote com 3 Super Stars — ideal para destacar vários matches.',
      icon: StoreProductIcon.superStar2,
      boostDuration: Duration.zero,
    ),
    StoreProduct(
      id: 'super_star_3',
      category: StoreItemCategory.superStar,
      label: '5 un.',
      priceLabel: 'R\$ 49,99',
      description:
          'Pacote com 5 Super Stars — melhor custo para quem usa com frequência.',
      icon: StoreProductIcon.superStar3,
      boostDuration: Duration.zero,
    ),
  ];

  static const superChatProducts = [
    StoreProduct(
      id: 'super_chat_1',
      category: StoreItemCategory.superChat,
      label: '1 un.',
      priceLabel: 'R\$ 11,99',
      description:
          '1 crédito de Super Chat: mensagem inicial em destaque com notificação.',
      icon: StoreProductIcon.superChat1,
      boostDuration: Duration.zero,
    ),
    StoreProduct(
      id: 'super_chat_2',
      category: StoreItemCategory.superChat,
      label: '3 un.',
      priceLabel: 'R\$ 27,99',
      description:
          '3 Super Chats para iniciar conversas com mais visibilidade.',
      icon: StoreProductIcon.superChat2,
      boostDuration: Duration.zero,
    ),
    StoreProduct(
      id: 'super_chat_3',
      category: StoreItemCategory.superChat,
      label: '5 un.',
      priceLabel: 'R\$ 49,99',
      description:
          '5 Super Chats — pacote econômico para contatos frequentes.',
      icon: StoreProductIcon.superChat3,
      boostDuration: Duration.zero,
    ),
  ];

  static const powerUpProducts = [
    StoreProduct(
      id: 'power_up_24h',
      category: StoreItemCategory.powerUp,
      label: '24 horas',
      priceLabel: 'R\$ 9,99',
      description:
          '24 h de destaque no feed da sua cidade. Permite mudar opinião no histórico.',
      icon: StoreProductIcon.powerUp1,
      boostDuration: Duration(hours: 24),
    ),
    StoreProduct(
      id: 'power_up_7d',
      category: StoreItemCategory.powerUp,
      label: '7 dias',
      priceLabel: 'R\$ 24,99',
      description:
          '7 dias de destaque + 1 Super Star e 1 Super Chat de bônus.',
      icon: StoreProductIcon.powerUp2,
      boostDuration: Duration(days: 7),
    ),
    StoreProduct(
      id: 'power_up_30d',
      category: StoreItemCategory.powerUp,
      label: '30 dias',
      priceLabel: 'R\$ 59,99',
      description:
          '30 dias de destaque + 4 Super Stars e 4 Super Chats de bônus.',
      icon: StoreProductIcon.powerUp3,
      boostDuration: Duration(days: 30),
    ),
  ];

  static List<StoreProduct> productsFor(StoreItemCategory category) =>
      switch (category) {
        StoreItemCategory.superStar => superStarProducts,
        StoreItemCategory.superChat => superChatProducts,
        StoreItemCategory.powerUp => powerUpProducts,
      };

  static List<StoreProduct> get allProducts => [
        ...powerUpProducts,
        ...superStarProducts,
        ...superChatProducts,
      ];

  static List<String> get allProductIds =>
      allProducts.map((product) => product.id).toList();
}
