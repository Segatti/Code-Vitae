import 'package:dio/dio.dart';

import '../../infra/datasources/api_datasource.dart';
import '../../infra/models/location_model.dart';
import '../../infra/models/locations_model.dart';

class RickMortyDatasource implements IApiDatasource {
  final String urlApi = 'https://rickandmortyapi.com/api';
  final Dio dio;

  const RickMortyDatasource({
    required this.dio,
  });

  @override
  Future<LocationsModel> getAll(int page) async {
    final response = await dio.get(
      '$urlApi/location/?page=$page',
    );
    if (response.statusCode == 200) {
      return LocationsModel.fromMap(response.data);
    } else {
      throw Exception('getAll - Status Code API: ${response.statusCode}}');
    }
  }

  @override
  Future<LocationModel> getOne(int id) async {
    final response = await dio.get('$urlApi/location/$id');
    if (response.statusCode == 200) {
      return LocationModel.fromMap(response.data);
    } else {
      throw Exception('getOne - Status Code API: ${response.statusCode}}');
    }
  }

  @override
  Future<List<LocationModel>> getMultiple(List<int> ids) async {
    String paramsIds = ids.join(',');
    final response = await dio.get(
      '$urlApi/location/$paramsIds',
    );
    if (response.statusCode == 200) {
      List<LocationModel> result = [];
      if (ids.length == 1) {
        result.add(LocationModel.fromMap(response.data));
      } else {
        for (var item in response.data) {
          result.add(LocationModel.fromMap(item));
        }
      }
      return result;
    } else {
      throw Exception('getMultiple - Status Code API: ${response.statusCode}}');
    }
  }
}
