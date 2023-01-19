import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/character_repository.dart';
import 'domain/usecases/get_all_characters.dart';
import 'domain/usecases/get_favorite_characters.dart';
import 'domain/usecases/get_one_character.dart';
import 'domain/usecases/set_favorite_characters.dart';
import 'external/rick_morty_api/rick_morty_datasource.dart';
import 'infra/datasources/api_datasource.dart';
import 'infra/repositories/character_repository.dart';
import 'presenter/pages/all_characters_page.dart';
import 'presenter/pages/character_page.dart';
import 'presenter/stores/all_characters_store.dart';
import 'presenter/stores/character_store.dart';

class CharactersModule extends Module {
  @override
  final List<Bind> binds = [
    // External
    Bind.singleton<IApiDatasource>((i) => RickMortyDatasource(dio: i())),

    // Repository
    Bind.singleton<ICharacterRepository>(
        (i) => CharacterRepository(apiDatasource: i())),

    // Use cases
    Bind.lazySingleton<IUCGetAllCharacters>(
        (i) => UCGetAllCharacters(characterRepository: i())),
    Bind.lazySingleton<IUCGetOneCharacter>(
        (i) => UCGetOneCharacter(characterRepository: i())),
    Bind.lazySingleton<IUCGetFavoriteCharacters>(
      (i) => UCGetFavoriteCharacters(getValueLocalStorage: i()),
      export: true,
    ),
    Bind.lazySingleton<IUCSetFavoriteCharacters>(
        (i) => UCSetFavoriteCharacters(setValueLocalStorage: i())),

    // Stores
    Bind.factory<AllCharactersStore>((i) => AllCharactersStore(i(), i(), i())),
    Bind.factory<CharacterStore>((i) => CharacterStore()),

    // Dependency
    Bind.singleton<Dio>((i) => Dio()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const AllCharactersPage()),
    ChildRoute(
      '/character',
      child: (_, args) => CharacterPage(
        id: args.params['id'],
      ),
    ),
  ];
}
