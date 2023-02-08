import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';
import 'package:morty_verso/app/app_module.dart';
import 'package:morty_verso/app/modules/locations/domain/entities/location.dart';
import 'package:morty_verso/app/modules/locations/domain/entities/locations.dart';
import 'package:morty_verso/app/modules/locations/domain/usecases/get_all_locations.dart';
import 'package:morty_verso/app/modules/locations/domain/usecases/get_one_location.dart';
import 'package:morty_verso/app/modules/locations/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/locations/infra/repositories/location_repository.dart';
import 'package:morty_verso/app/modules/locations/locations_module.dart';

import '../../utils/json_response.dart';
import 'location_module_test.mocks.dart';

@GenerateMocks([Dio, LocationRepository, RickMortyDatasource])
void main() {
  final dio = MockDio();

  initModules(
    [
      AppModule(),
      LocationsModule(),
    ],
    replaceBinds: [
      Bind.singleton<Dio>((i) => dio),
    ],
  );

  /// Só caso de sucesso, pois as todas as falhas ja são testadas em outros arquivos

  group('Sucessos', () {
    test('Buscar todos os locais', () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(allLocations),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final usecase = Modular.get<IUCGetAllLocations>();
      final result = await usecase(1);

      expect(result, isA<dartz.Right>());
      expect(result.fold((l) => l, (r) => r), isA<Locations>());
    });

    test('Buscar um local', () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(oneLocation),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final usecase = Modular.get<IUCGetOneLocation>();
      final result = await usecase(1);

      expect(result, isA<dartz.Right>());
      expect(result.fold((l) => l, (r) => r), isA<Location>());
    });
  });
}
