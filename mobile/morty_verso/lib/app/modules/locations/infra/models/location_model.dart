// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:collection/collection.dart';

import '../../domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    super.id,
    super.name,
    super.type,
    super.dimension,
    super.residents,
    super.url,
    super.created,
  });

  LocationModel copyWith({
    int? id,
    String? name,
    String? type,
    String? dimension,
    List<String>? residents,
    String? url,
    String? created,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dimension: dimension ?? this.dimension,
      residents: residents ?? this.residents,
      url: url ?? this.url,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'dimension': dimension,
      'residents': residents,
      'url': url,
      'created': created,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      dimension: map['dimension'] != null ? map['dimension'] as String : null,
      residents: map['residents'] != null
          ? List<String>.from((map['residents'] as List))
          : null,
      url: map['url'] != null ? map['url'] as String : null,
      created: map['created'] != null ? map['created'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, type: $type, dimension: $dimension, residents: $residents, url: $url, created: $created)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.dimension == dimension &&
        listEquals(other.residents, residents) &&
        other.url == url &&
        other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        dimension.hashCode ^
        residents.hashCode ^
        url.hashCode ^
        created.hashCode;
  }
}
