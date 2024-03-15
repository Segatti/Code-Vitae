enum TypeAnswer {
  none,
  like,
  superStar,
  dislike,
  chat,
  superChat;

  const TypeAnswer();
  static TypeAnswer getType(String value) {
    for (var item in TypeAnswer.values) {
      if (item.name == value) return item;
    }
    return TypeAnswer.none;
  }
}
