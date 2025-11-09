enum UserHousework {
  none,
  cleaning,
  cooking,
  laundry,
  shopping,
  dishwashing,
  trash,
  bathroom;

  String get title => switch (this) {
    none => "",
    cleaning => "Limpar casa",
    cooking => "Cozinhar",
    laundry => "Lavar roupas",
    shopping => "Fazer mercado",
    dishwashing => "Lavar louças",
    trash => "Retirar lixo",
    bathroom => "Limpar banheiro",
  };

  static UserHousework get(String value) {
    for (var item in UserHousework.values) {
      if (item.name == value) {
        return item;
      }
    }
    return UserHousework.none;
  }
}
