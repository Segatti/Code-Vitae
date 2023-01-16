import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/core/domain/errors/failure.dart';

import '../entities/character.dart';
import '../entities/characters.dart';

abstract class ICharacterRepository {
  Future<Either<Failure, Characters>> getAll(int page);
  Future<Either<Failure, Character>> getOne(int id);
}
