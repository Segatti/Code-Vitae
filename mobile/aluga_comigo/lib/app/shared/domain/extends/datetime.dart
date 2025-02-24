extension DateListExt on List<DateTime> {
  DateTime findEarliestDate() {
    if (isEmpty) {
      throw ArgumentError("A lista de datas não pode estar vazia.");
    }

    return reduce((a, b) => a.isBefore(b) ? a : b);
  }

  DateTime findOldestDate() {
    if (isEmpty) {
      throw ArgumentError("A lista de datas não pode estar vazia.");
    }

    return reduce((a, b) => a.isBefore(b) ? b : a);
  }
}
