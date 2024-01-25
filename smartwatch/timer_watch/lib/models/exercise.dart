import 'dart:convert';

class Exercise {
  final String? name;
  final String? load;
  final num? series;
  final num? repetitions;
  final num? timeExecution;
  final num? timeResting;

  const Exercise({
    this.name,
    this.load,
    this.series,
    this.repetitions,
    this.timeExecution,
    this.timeResting,
  });

  Exercise copyWith({
    String? name,
    String? load,
    num? series,
    num? repetitions,
    num? timeExecution,
    num? timeResting,
  }) {
    return Exercise(
      name: name ?? this.name,
      load: load ?? this.load,
      series: series ?? this.series,
      repetitions: repetitions ?? this.repetitions,
      timeExecution: timeExecution ?? this.timeExecution,
      timeResting: timeResting ?? this.timeResting,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'load': load,
      'series': series,
      'repetitions': repetitions,
      'timeExecution': timeExecution,
      'timeResting': timeResting,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] != null ? map['name'] as String : null,
      load: map['load'] != null ? map['load'] as String : null,
      series: map['series'] != null ? map['series'] as num : null,
      repetitions:
          map['repetitions'] != null ? map['repetitions'] as num : null,
      timeExecution:
          map['timeExecution'] != null ? map['timeExecution'] as num : null,
      timeResting:
          map['timeResting'] != null ? map['timeResting'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Exercise(name: $name, load: $load, series: $series, repetitions: $repetitions, timeExecution: $timeExecution, timeResting: $timeResting)';
  }

  @override
  bool operator ==(covariant Exercise other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.load == load &&
        other.series == series &&
        other.repetitions == repetitions &&
        other.timeExecution == timeExecution &&
        other.timeResting == timeResting;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        load.hashCode ^
        series.hashCode ^
        repetitions.hashCode ^
        timeExecution.hashCode ^
        timeResting.hashCode;
  }
}
