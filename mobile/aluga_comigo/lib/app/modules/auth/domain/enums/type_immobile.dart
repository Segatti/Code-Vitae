enum TypeImmobile {
  none,
  house,
  apartment;

  static TypeImmobile get(String value) {
    for (var item in TypeImmobile.values) {
      if (item.name == value) {
        return item;
      }
    }
    return TypeImmobile.none;
  }
}
