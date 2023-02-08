import 'package:dio/dio.dart';

import '../../infra/datasources/api_datasource.dart';
import '../../infra/models/episode_model.dart';
import '../../infra/models/episodes_model.dart';

class RickMortyDatasource implements IApiDatasource {
  final String urlApi = 'https://rickandmortyapi.com/api';
  final Dio dio;

  const RickMortyDatasource({
    required this.dio,
  });

  @override
  Future<EpisodesModel> getAll(int page) async {
    final response = await dio.get(
      '$urlApi/episode/?page=$page',
    );
    if (response.statusCode == 200) {
      return EpisodesModel.fromMap(response.data);
    } else {
      throw Exception('getAll - Status Code API: ${response.statusCode}}');
    }
  }

  @override
  Future<EpisodeModel> getOne(int id) async {
    final response = await dio.get('$urlApi/episode/$id');
    if (response.statusCode == 200) {
      return EpisodeModel.fromMap(response.data);
    } else {
      throw Exception('getOne - Status Code API: ${response.statusCode}}');
    }
  }

  @override
  Future<List<EpisodeModel>> getMultiple(List<int> ids) async {
    String paramsIds = ids.join(',');
    final response = await dio.get(
      '$urlApi/episode/$paramsIds',
    );
    if (response.statusCode == 200) {
      List<EpisodeModel> result = [];
      if (ids.length == 1) {
        result.add(EpisodeModel.fromMap(response.data));
      } else {
        for (var item in response.data) {
          result.add(EpisodeModel.fromMap(item));
        }
      }
      return result;
    } else {
      throw Exception('getMultiple - Status Code API: ${response.statusCode}}');
    }
  }
}
