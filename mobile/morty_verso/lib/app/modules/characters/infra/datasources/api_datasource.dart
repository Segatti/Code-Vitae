import '../models/character_model.dart';
import '../models/characters_model.dart';

abstract class IApiDatasource {
  Future<CharacterModel> getOne(int id);
  Future<CharactersModel> getAll(int page);
  Future<List<CharacterModel>> getMultiple(List<int> ids);
}
