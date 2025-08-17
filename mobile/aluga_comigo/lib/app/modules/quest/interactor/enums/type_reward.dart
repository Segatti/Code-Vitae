enum TypeRewards {
  none,
  like,
  superStar,
  superChat;

  const TypeRewards();

  static getType(String value) {
    for (var item in TypeRewards.values) {
      if (item.name == value) return item;
    }
    return TypeRewards.none;
  }
}
