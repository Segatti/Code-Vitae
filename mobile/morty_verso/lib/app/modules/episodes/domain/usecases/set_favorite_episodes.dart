import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/errors/local_storage_error.dart';
import '../../../../core/domain/usecases/set_value_local_storage.dart';

abstract class IUCSetFavoriteEpisodes {
  Future<Either<Failure, void>> call(String key, List<String> episodeIdList);
}

class UCSetFavoriteEpisodes implements IUCSetFavoriteEpisodes {
  final IUCSetValueLocalStorage setValueLocalStorage;

  const UCSetFavoriteEpisodes({required this.setValueLocalStorage});

  @override
  Future<Either<Failure, void>> call(
      String key, List<String> episodeIdList) async {
    try {
      if (key.isNotEmpty) {
        String source = json.encode(episodeIdList);
        setValueLocalStorage(key, source);
        return const Right(null);
      } else {
        return Left(KeyError('UCSetFavoriteEpisodes - KeyError'));
      }
    } catch (e) {
      return Left(ItemValueError('UCSetFavoriteEpisodes - ItemValueError'));
    }
  }
}
