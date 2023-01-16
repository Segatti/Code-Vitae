import 'dart:convert';

import 'package:morty_verso/app/modules/characters/domain/entities/character_origin.dart';

class CharacterOriginModel extends CharacterOrigin {
  const CharacterOriginModel({
    required super.name,
    required super.url,
  });

  CharacterOriginModel copyWith({
    String? name,
    String? url,
  }) {
    return CharacterOriginModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory CharacterOriginModel.fromMap(Map<String, dynamic> map) {
    return CharacterOriginModel(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterOriginModel.fromJson(String source) =>
      CharacterOriginModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CharacterOriginModel(name: $name, url: $url)';

  @override
  bool operator ==(covariant CharacterOriginModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
