import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/episode_repository.dart';
import 'domain/usecases/get_all_episodes.dart';
import 'domain/usecases/get_favorite_episodes.dart';
import 'domain/usecases/get_multiple_episodes.dart';
import 'domain/usecases/get_one_episode.dart';
import 'domain/usecases/set_favorite_episodes.dart';
import 'external/rick_morty_api/rick_morty_datasource.dart';
import 'infra/datasources/api_datasource.dart';
import 'infra/repositories/episode_repository.dart';
import 'presenter/pages/all_episodes_page.dart';
import 'presenter/pages/characters_page.dart';
import 'presenter/stores/all_episodes_store.dart';
import 'presenter/stores/characters_store.dart';

class EpisodesModule extends Module {
  @override
  final List<Bind> binds = [
    // External
    Bind.singleton<IApiDatasource>((i) => RickMortyDatasource(dio: i()),
        export: true),

    // Repository
    Bind.singleton<IEpisodeRepository>(
        (i) => EpisodeRepository(apiDatasource: i()),
        export: true),

    // Use cases
    Bind.singleton<IUCGetAllEpisodes>(
        (i) => UCGetAllEpisodes(episodeRepository: i())),
    Bind.singleton<IUCGetOneEpisode>(
        (i) => UCGetOneEpisode(episodeRepository: i())),
    Bind.singleton<IUCGetFavoriteEpisodes>(
      (i) => UCGetFavoriteEpisodes(getValueLocalStorage: i()),
      export: true,
    ),
    Bind.singleton<IUCSetFavoriteEpisodes>(
        (i) => UCSetFavoriteEpisodes(setValueLocalStorage: i())),
    Bind.singleton<IUCGetMultipleEpisodes>(
        (i) => UCGetMultipleEpisodes(episodeRepository: i()),
        export: true),

    // Stores
    Bind.factory<AllEpisodesStore>((i) => AllEpisodesStore(i(), i(), i())),
    Bind.factory<CharactersStore>((i) => CharactersStore(i())),

    // Dependency
    Bind.singleton<Dio>((i) => Dio(), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const AllEpisodesPage(),
      transition: TransitionType.rightToLeft,
    ),
    ChildRoute(
      '/characters',
      child: (_, args) => CharactersPage(
        ids: args.data['characters_ids'],
        episodeName: args.data['episode_name'],
      ),
      transition: TransitionType.rightToLeft,
    ),
  ];
}
