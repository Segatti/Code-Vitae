// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/modules/characters/domain/errors/character_error.dart';

import '../../../../core/domain/errors/failure.dart';
import '../entities/characters.dart';
import '../repositories/character_repository.dart';

abstract class IUCGetAllCharacters {
  Future<Either<Failure, Characters>> call(int page);
}

class UCGetAllCharacters implements IUCGetAllCharacters {
  ICharacterRepository characterRepository;

  UCGetAllCharacters({
    required this.characterRepository,
  });

  @override
  Future<Either<Failure, Characters>> call(int page) async {
    if (page < 0) {
      return Left(InvalidInput());
    } else {
      final response = await characterRepository.getAll(page);
      return response.fold(
        (error) => Left(error),
        (response) => (response.results?.isEmpty ?? true)
            ? Left(EmptyList())
            : Right(response),
      );
    }
  }
}
