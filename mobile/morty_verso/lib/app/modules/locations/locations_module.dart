import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/location_repository.dart';
import 'domain/usecases/get_all_locations.dart';
import 'domain/usecases/get_favorite_locations.dart';
import 'domain/usecases/get_multiple_locations.dart';
import 'domain/usecases/get_one_location.dart';
import 'domain/usecases/set_favorite_locations.dart';
import 'external/rick_morty_api/rick_morty_datasource.dart';
import 'infra/datasources/api_datasource.dart';
import 'infra/repositories/location_repository.dart';
import 'presenter/pages/all_locations_page.dart';
import 'presenter/pages/residents_page.dart';
import 'presenter/stores/all_locations_store.dart';
import 'presenter/stores/residents_store.dart';

class LocationsModule extends Module {
  @override
  final List<Bind> binds = [
    // External
    Bind.singleton<IApiDatasource>((i) => RickMortyDatasource(dio: i()),
        export: true),

    // Repository
    Bind.singleton<ILocationRepository>(
        (i) => LocationRepository(apiDatasource: i()),
        export: true),

    // Use cases
    Bind.singleton<IUCGetAllLocations>(
        (i) => UCGetAllLocations(locationRepository: i())),
    Bind.singleton<IUCGetOneLocation>(
        (i) => UCGetOneLocation(locationRepository: i())),
    Bind.singleton<IUCGetFavoriteLocations>(
      (i) => UCGetFavoriteLocations(getValueLocalStorage: i()),
      export: true,
    ),
    Bind.singleton<IUCSetFavoriteLocations>(
        (i) => UCSetFavoriteLocations(setValueLocalStorage: i())),
    Bind.singleton<IUCGetMultipleLocations>(
        (i) => UCGetMultipleLocations(locationRepository: i()),
        export: true),

    // Stores
    Bind.factory<AllLocationsStore>((i) => AllLocationsStore(i(), i(), i())),
    Bind.factory<ResidentsStore>((i) => ResidentsStore(i())),

    // Dependency
    Bind.singleton<Dio>((i) => Dio(), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const AllLocationsPage(),
      transition: TransitionType.rightToLeft,
    ),
    ChildRoute(
      '/residets',
      child: (_, args) => ResidentsPage(
        ids: args.data['location_id'],
        locationName: args.data['location_name'],
      ),
      transition: TransitionType.rightToLeft,
    ),
  ];
}
