import '../models/episode_model.dart';
import '../models/episodes_model.dart';

abstract class IApiDatasource {
  Future<EpisodeModel> getOne(int id);
  Future<EpisodesModel> getAll(int page);
  Future<List<EpisodeModel>> getMultiple(List<int> ids);
}
