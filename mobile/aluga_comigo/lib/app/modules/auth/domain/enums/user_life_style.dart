enum UserLifeStyle {
  none,
  partying,
  stayingAtHome,
  working;

  String get title => switch (this) {
    none => "",
    partying => "Festeiro",
    stayingAtHome => "Só fico em casa",
    working => "Focado no trabalho",
  };

  static UserLifeStyle get(String value) {
    for (var item in UserLifeStyle.values) {
      if (item.name == value) {
        return item;
      }
    }
    return UserLifeStyle.none;
  }
}