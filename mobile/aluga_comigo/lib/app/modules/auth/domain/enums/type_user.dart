enum TypeUser {
  none,
  person,
  immobile;

  static TypeUser get(String? value) {
    for (var item in TypeUser.values) {
      if (item.name == value) {
        return item;
      }
    }
    return TypeUser.none;
  }
}
