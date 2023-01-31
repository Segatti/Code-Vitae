// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../../core/infra/models/info_assistant_model.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/episodes.dart';
import 'episode_model.dart';


class EpisodesModel extends Episodes {
  @override
  final InfoAssistantModel? info;
  @override
  final List<EpisodeModel>? results;

  const EpisodesModel({
    this.info,
    this.results,
  });

  EpisodesModel copyWith({
    InfoAssistantModel? info,
    List<EpisodeModel>? results,
  }) {
    return EpisodesModel(
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

  factory EpisodesModel.fromMap(Map<String, dynamic> map) {
    return EpisodesModel(
      info: map['info'] != null
          ? InfoAssistantModel.fromMap(map['info'] as Map<String, dynamic>)
          : null,
      results: map['results'] != null
          ? List<EpisodeModel>.from(
              (map['results'] as List).map<Episode?>(
                (x) => EpisodeModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EpisodesModel.fromJson(String source) =>
      EpisodesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EpisodesModel(info: $info, results: $results)';

  @override
  bool operator ==(covariant EpisodesModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.info == info && listEquals(other.results, results);
  }

  @override
  int get hashCode => info.hashCode ^ results.hashCode;
}
