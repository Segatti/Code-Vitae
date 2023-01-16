import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';
import 'package:morty_verso/app/modules/characters/infra/repositories/character_repository.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/character.dart';

abstract class IUCGetOneCharacters {
  Future<Either<Failure, Character>> call(int id);
}

class UCGetOneCharacters implements IUCGetOneCharacters {
  CharacterRepository characterRepository;

  UCGetOneCharacters({
    required this.characterRepository,
  });

  @override
  Future<Either<Failure, Character>> call(int id) async {
    if (id < 0) {
      return Left(InvalidInput());
    } else {
      final response = await characterRepository.getOne(id);
      return response.fold(
        (error) => Left(InfraError()),
        (response) => Right(response),
      );
    }
  }
}
