import 'dart:convert';

import 'package:morty_verso/app/modules/characters/domain/entities/character_location.dart';

class CharacterLocationModel extends CharacterLocation {

  CharacterLocationModel({
    required super.name,
    required super.url,
  });

  CharacterLocationModel copyWith({
    String? name,
    String? url,
  }) {
    return CharacterLocationModel(
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

  factory CharacterLocationModel.fromMap(Map<String, dynamic> map) {
    return CharacterLocationModel(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterLocationModel.fromJson(String source) => CharacterLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CharacterLocationModel(name: $name, url: $url)';

  @override
  bool operator ==(covariant CharacterLocationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
