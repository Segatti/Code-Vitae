import '../models/location_model.dart';
import '../models/locations_model.dart';

abstract class IApiDatasource {
  Future<LocationModel> getOne(int id);
  Future<LocationsModel> getAll(int page);
  Future<List<LocationModel>> getMultiple(List<int> ids);
}
