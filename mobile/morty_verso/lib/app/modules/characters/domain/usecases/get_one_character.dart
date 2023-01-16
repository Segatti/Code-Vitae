import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

abstract class IUCGetOneCharacter {
  Future<Either<Failure, Character>> call(int id);
}

class UCGetOneCharacter implements IUCGetOneCharacter {
  ICharacterRepository characterRepository;

  UCGetOneCharacter({
    required this.characterRepository,
  });

  @override
  Future<Either<Failure, Character>> call(int id) async {
    if (id < 0) {
      return Left(InvalidInput());
    } else {
      final response = await characterRepository.getOne(id);
      return response.fold(
        (error) => Left(error),
        (response) => Right(response),
      );
    }
  }
}
