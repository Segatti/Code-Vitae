enum TicketReaction {
  like,
  dislike;

  String get storageValue => name;

  static TicketReaction? fromStorage(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final item in TicketReaction.values) {
      if (item.name == value) return item;
    }
    return null;
  }
}
