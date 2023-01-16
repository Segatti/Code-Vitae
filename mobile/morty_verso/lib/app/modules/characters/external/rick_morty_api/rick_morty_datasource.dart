import 'package:dio/dio.dart';

import '../../infra/datasources/api_datasource.dart';
import '../../infra/models/character_model.dart';
import '../../infra/models/characters_model.dart';

class RickMortyDatasource implements ApiDatasource {
  String urlApi = 'https://rickandmortyapi.com/api/';
  Dio dio;

  RickMortyDatasource({
    required this.dio,
  });

  @override
  Future<CharactersModel> getAll(int page) async {
    final response = await dio.get(
      '$urlApi/character/?page=$page',
    );
    if (response.statusCode == 200) {
      return CharactersModel.fromMap(response.data);
    } else {
      throw Exception('getAll - Status Code API: ${response.statusCode}}');
    }
  }

  @override
  Future<CharacterModel> getOne(int id) async {
    final response = await dio.get('$urlApi/character/$id');
    if (response.statusCode == 200) {
      return CharacterModel.fromMap(response.data);
    } else {
      throw Exception('getOne - Status Code API: ${response.statusCode}}');
    }
  }
}
