enum MessageType {
  none,
  text,
  photo;

  static MessageType getType(String value) {
    for (var item in MessageType.values) {
      if (value == item.name) return item;
    }
    return none;
  }
}
