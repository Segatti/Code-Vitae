enum MinutesInTime {
  hours(60),
  days(1440),
  months(43200),
  years(518400);

  final int value;

  const MinutesInTime(this.value);
}
