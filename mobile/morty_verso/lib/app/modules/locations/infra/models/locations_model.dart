// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../../core/infra/models/info_assistant_model.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/locations.dart';
import 'location_model.dart';


class LocationsModel extends Locations {
  @override
  final InfoAssistantModel? info;
  @override
  final List<LocationModel>? results;

  const LocationsModel({
    this.info,
    this.results,
  });

  LocationsModel copyWith({
    InfoAssistantModel? info,
    List<LocationModel>? results,
  }) {
    return LocationsModel(
      info: info ?? this.info,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'info': info?.toMap(),
      'results': results?.map((x) => x.toMap()).toList(),
    };
  }

  factory LocationsModel.fromMap(Map<String, dynamic> map) {
    return LocationsModel(
      info: map['info'] != null
          ? InfoAssistantModel.fromMap(map['info'] as Map<String, dynamic>)
          : null,
      results: map['results'] != null
          ? List<LocationModel>.from(
              (map['results'] as List).map<Location?>(
                (x) => LocationModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationsModel.fromJson(String source) =>
      LocationsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocationsModel(info: $info, results: $results)';

  @override
  bool operator ==(covariant LocationsModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.info == info && listEquals(other.results, results);
  }

  @override
  int get hashCode => info.hashCode ^ results.hashCode;
}
