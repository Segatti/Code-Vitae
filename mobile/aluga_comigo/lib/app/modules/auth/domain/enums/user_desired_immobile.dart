enum UserDesiredImmobile {
  none,
  apartment,
  house,
  houseOrApartment;

  String get title => switch (this) {
    none => "",
    apartment => "Apartamento",
    house => "Casa",
    houseOrApartment => "Casa ou Apartamento",
  };

  static UserDesiredImmobile get(String value) {
    for (var item in UserDesiredImmobile.values) {
      if (item.name == value) {
        return item;
      }
    }
    return UserDesiredImmobile.none;
  }
}