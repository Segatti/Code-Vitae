import 'package:morty_verso/app/core/domain/entities/info_assistant.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';

class Characters {
  final InfoAssistant? info;
  final List<Character>? results;

  const Characters({
    this.info,
    this.results,
  });
}
