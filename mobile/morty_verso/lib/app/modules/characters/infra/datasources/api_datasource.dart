import '../models/character_model.dart';
import '../models/characters_model.dart';

abstract class ApiDatasource {
  Future<CharacterModel> getOne(int id);
  Future<CharactersModel> getAll(int page);
}
