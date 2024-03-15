enum TypeCard {
  none,
  customer,
  house;

  const TypeCard();
  static TypeCard getType(String value) {
    for (var item in TypeCard.values) {
      if (item.name == value) return item;
    }
    return TypeCard.none;
  }
}
