enum HomeType {
  none(''),
  house('Casa'),
  apartment('Ap.'),
  both('Casa/Ap.');

  final String text;
  const HomeType(this.text);

  static HomeType getType(String value) {
    for (var item in HomeType.values) {
      if (value == item.name) return item;
    }
    return none;
  }
}
