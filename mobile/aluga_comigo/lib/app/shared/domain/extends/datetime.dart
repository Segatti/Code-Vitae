import 'package:dart_date/dart_date.dart';

extension DateTimeExt on DateTime {
  bool isBetween(DateTime start, DateTime end, {bool includeEnd = true}) {
    return (includeEnd)
        ? isSameOrAfter(start) && isSameOrBefore(end)
        : isSameOrAfter(start) && isBefore(end);
  }

  int timestampUtc() {
    return addHours(timeZoneOffset.inHours).timestamp;
  }

  DateTime setTime(String time) {
    var timeParts = time.split(":");

    return setHour(int.parse(timeParts.first)).setMinute(int.parse(timeParts.last));
  }
}

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
