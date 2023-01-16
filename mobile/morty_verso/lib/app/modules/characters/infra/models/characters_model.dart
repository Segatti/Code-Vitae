// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../../core/infra/models/info_assistant_model.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/characters.dart';
import 'character_model.dart';

class CharactersModel extends Characters {
  @override
  final InfoAssistantModel? info;
  @override
  final List<CharacterModel>? results;
  
  const CharactersModel({
    this.info,
    this.results,
  });

  CharactersModel copyWith({
    InfoAssistantModel? info,
    List<CharacterModel>? results,
  }) {
    return CharactersModel(
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

  factory CharactersModel.fromMap(Map<String, dynamic> map) {
    return CharactersModel(
      info: map['info'] != null
          ? InfoAssistantModel.fromMap(map['info'] as Map<String, dynamic>)
          : null,
      results: map['results'] != null
          ? List<CharacterModel>.from(
              (map['results'] as List).map<Character?>(
                (x) => CharacterModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharactersModel.fromJson(String source) =>
      CharactersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CharactersModel(info: $info, results: $results)';

  @override
  bool operator ==(covariant CharactersModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.info == info && listEquals(other.results, results);
  }

  @override
  int get hashCode => info.hashCode ^ results.hashCode;
}
