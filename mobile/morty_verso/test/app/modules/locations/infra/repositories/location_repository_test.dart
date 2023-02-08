import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/locations/domain/errors/location_error.dart';
import 'package:morty_verso/app/modules/locations/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/locations/infra/models/location_model.dart';
import 'package:morty_verso/app/modules/locations/infra/models/locations_model.dart';
import 'package:morty_verso/app/modules/locations/infra/repositories/location_repository.dart';

import 'location_repository_test.mocks.dart';

@GenerateMocks([RickMortyDatasource])
void main() {
  final datasource = MockRickMortyDatasource();
  final repository = LocationRepository(apiDatasource: datasource);

  group('Sucessos', () {
    test('Buscar todos os locais pelo Datasource', () async {
      when(datasource.getAll(any)).thenAnswer((_) async => const LocationsModel());

      final result = await repository.getAll(1);
      expect(result.fold(id, id), isA<LocationsModel>());
    });

    test('Buscar um local pelo Datasource', () async {
      when(datasource.getOne(any)).thenAnswer((_) async => LocationModel());

      final result = await repository.getOne(1);
      expect(result.fold(id, id), isA<LocationModel>());
    });
  });

  group('Erros', () {
    test('Erro no Datasource ao tentar buscar todos os locais',
        () async {
      when(datasource.getAll(any)).thenThrow((_) async => DatasourceError(''));

      final result = await repository.getAll(1);
      expect(result.fold(id, id), isA<DatasourceError>());
    });

    test('Erro no Datasource ao tentar buscar um local', () async {
      when(datasource.getOne(any)).thenThrow((_) async => DatasourceError(''));

      final result = await repository.getOne(1);
      expect(result.fold(id, id), isA<DatasourceError>());
    });
  });
}
