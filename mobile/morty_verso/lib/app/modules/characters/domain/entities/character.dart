import 'character_location.dart';
import 'character_origin.dart';

class Character {
  final int? id;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;
  final CharacterOrigin? origin;
  final CharacterLocation? location;
  final String? image;
  final List<String>? episode;
  final String? url;
  final String? created;

  const Character({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.origin,
    this.location,
    this.image,
    this.episode,
    this.url,
    this.created,
  });
}
