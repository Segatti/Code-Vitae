String validText(String value) {
  List<String> splitText = value.trim().split(' ');
  List<String> aux = [];
  for (var item in splitText) {
    if (item.contains('(') || item.contains(')')) {
      aux.add(item);
    } else {
      aux.add("${item[0].toUpperCase()}${item.substring(1).toLowerCase()}");
    }
  }
  return aux.join(' ');
}
