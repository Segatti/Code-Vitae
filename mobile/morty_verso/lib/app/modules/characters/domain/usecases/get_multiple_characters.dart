import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

abstract class IUCGetMultipleCharacters {
  Future<Either<Failure, List<Character>>> call(List<int> ids);
}

class UCGetMultipleCharacters implements IUCGetMultipleCharacters {
  final ICharacterRepository characterRepository;

  const UCGetMultipleCharacters({
    required this.characterRepository,
  });

  @override
  Future<Either<Failure, List<Character>>> call(List<int> ids) async {
    if (ids.isEmpty) {
      return Left(InvalidInput('UCGetMultipleCharacters - InvalidInput'));
    } else {
      final response = await characterRepository.getMultiple(ids);
      return response.fold(
        (error) => Left(error),
        (response) => Right(response),
      );
    }
  }
}
