enum TypeImmobile {
  none,
  house,
  apartment;
}

TypeImmobile getTypeImmobile(String value) {
  for (var item in TypeImmobile.values) {
    if (item.name == value) {
      return item;
    }
  }
  return TypeImmobile.none;
}
