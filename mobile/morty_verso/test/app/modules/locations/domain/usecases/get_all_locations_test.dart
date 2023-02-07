import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/locations/domain/entities/location.dart';
import 'package:morty_verso/app/modules/locations/domain/entities/locations.dart';
import 'package:morty_verso/app/modules/locations/domain/errors/location_error.dart';
import 'package:morty_verso/app/modules/locations/domain/usecases/get_all_locations.dart';
import 'package:morty_verso/app/modules/locations/infra/repositories/location_repository.dart';

import 'get_all_locations_test.mocks.dart';

@GenerateMocks([LocationRepository])
void main() {
  final repository = MockLocationRepository();
  final usecase = UCGetAllLocations(locationRepository: repository);

  test('Sucesso: Buscar todos os locais', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Locations(results: [Location()])),
    );

    final result = await usecase(1);

    expect(result.fold(id, id), isA<Locations>());
  });

  test('Erro: Lista vazia', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Locations(results: [])),
    );

    final result = await usecase(1);

    expect(result.fold(id, id), isA<EmptyList>());
  });

  test('Erro: Input Invalido', () async {
    when(repository.getAll(any)).thenAnswer(
      (_) async => const Right(Locations()),
    );

    final result = await usecase(-1);

    expect(result.fold(id, id), isA<InvalidInput>());
  });
}
