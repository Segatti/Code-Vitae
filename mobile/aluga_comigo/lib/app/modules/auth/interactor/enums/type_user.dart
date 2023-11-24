enum TypeUser {
  none,
  person,
  immobile;
}

TypeUser getTypeUser(String value) {
  for (var item in TypeUser.values) {
    if (item.name == value) {
      return item;
    }
  }
  return TypeUser.none;
}
