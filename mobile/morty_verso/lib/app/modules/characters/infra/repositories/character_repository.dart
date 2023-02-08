import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/characters.dart';
import '../../domain/errors/character_error.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/api_datasource.dart';

class CharacterRepository implements ICharacterRepository {
  final IApiDatasource apiDatasource;

  const CharacterRepository({
    required this.apiDatasource,
  });

  @override
  Future<Either<Failure, Characters>> getAll(int page) async {
    try {
      final response = await apiDatasource.getAll(page);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('CharacterRepository.getAll - DatasourceError'));
    }
  }

  @override
  Future<Either<Failure, Character>> getOne(int id) async {
    try {
      final response = await apiDatasource.getOne(id);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('CharacterRepository.getOne - DatasourceError'));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> getMultiple(List<int> ids) async {
    try {
      final response = await apiDatasource.getMultiple(ids);
      return Right(response);
    } catch (e) {
      return Left(
          DatasourceError('CharacterRepository.getMultiple - DatasourceError'));
    }
  }
}
