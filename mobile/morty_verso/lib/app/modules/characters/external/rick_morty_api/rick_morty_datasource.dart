import 'dart:developer';

import 'package:dio/dio.dart';

import '../../infra/datasources/api_datasource.dart';
import '../../infra/models/character_model.dart';
import '../../infra/models/characters_model.dart';

class RickMortyDatasource implements IApiDatasource {
  final String urlApi = 'https://rickandmortyapi.com/api';
  final Dio dio;

  const RickMortyDatasource({
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

  @override
  Future<List<CharacterModel>> getMultiple(List<int> ids) async {
    String paramsIds = ids.join(',');
    final response = await dio.get(
      '$urlApi/character/$paramsIds',
    );
    if (response.statusCode == 200) {
      List<CharacterModel> result = [];
      if (ids.length == 1) {
        result.add(CharacterModel.fromMap(response.data));
      } else {
        for (var item in response.data) {
          result.add(CharacterModel.fromMap(item));
        }
      }
      return result;
    } else {
      throw Exception('getMultiple - Status Code API: ${response.statusCode}}');
    }
  }
}
