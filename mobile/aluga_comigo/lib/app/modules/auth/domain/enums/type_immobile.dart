enum TypeImmobile {
  none,
  house,
  apartment;

  String get title => switch (this) {
    none => "",
    house => "Casa",
    apartment => "Apartamento",
  };

  static TypeImmobile get(String value) {
    for (var item in TypeImmobile.values) {
      if (item.name == value) {
        return item;
      }
    }
    return TypeImmobile.none;
  }
}
