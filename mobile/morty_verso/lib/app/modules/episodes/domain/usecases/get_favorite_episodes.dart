import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:morty_verso/app/core/domain/usecases/get_value_local_storage.dart';

import '../../../../core/domain/errors/failure.dart';
import '../../../../core/domain/errors/local_storage_error.dart';

abstract class IUCGetFavoriteEpisodes {
  Future<Either<Failure, List<String>>> call();
}

class UCGetFavoriteEpisodes implements IUCGetFavoriteEpisodes {
  final IUCGetValueLocalStorage getValueLocalStorage;

  const UCGetFavoriteEpisodes({required this.getValueLocalStorage});

  @override
  Future<Either<Failure, List<String>>> call() async {
    try {
      final result = await getValueLocalStorage('favorite_episodes');
      List<String> episodeIdList = [];
      return result.fold(
        (l) => Left(l),
        (r) {
          if (r != null) {
            episodeIdList =
                (json.decode(r) as List).map((e) => e.toString()).toList();
          }
          return Right(episodeIdList);
        },
      );
    } catch (e) {
      return Left(ItemValueError('UCGetFavoriteEpisodes - ItemValueError'));
    }
  }
}
