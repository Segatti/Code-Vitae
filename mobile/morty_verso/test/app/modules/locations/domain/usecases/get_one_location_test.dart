import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/locations/domain/entities/location.dart';
import 'package:morty_verso/app/modules/locations/domain/errors/location_error.dart';
import 'package:morty_verso/app/modules/locations/domain/usecases/get_one_location.dart';
import 'package:morty_verso/app/modules/locations/infra/repositories/location_repository.dart';

import 'get_one_location_test.mocks.dart';

@GenerateMocks([LocationRepository])
void main() {
  final repository = MockLocationRepository();
  final usecase = UCGetOneLocation(locationRepository: repository);

  test('Sucesso: Buscar um local', () async {
    when(repository.getOne(any))
        .thenAnswer((_) async => const Right(Location()));

    final result = await usecase(1);
    expect(result.fold(id, id), isA<Location>());
  });

  test('Error: Id invalido', () async {
    when(repository.getOne(any))
        .thenAnswer((_) async => const Right(Location()));

    final result = await usecase(-1);
    expect(result.fold(id, id), isA<InvalidInput>());
  });
}
