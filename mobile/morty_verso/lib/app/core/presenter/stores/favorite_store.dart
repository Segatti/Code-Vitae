// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../../modules/characters/domain/usecases/get_favorite_characters.dart';
import '../../../modules/characters/domain/usecases/get_multiple_characters.dart';
import '../../../modules/episodes/domain/usecases/get_favorite_episodes.dart';
import '../../../modules/episodes/domain/usecases/get_multiple_episodes.dart';
import '../../../modules/locations/domain/usecases/get_favorite_locations.dart';
import '../../../modules/locations/domain/usecases/get_multiple_locations.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/entities/page_states.dart';
part 'favorite_store.g.dart';

class FavoriteStore = _FavoriteStoreBase with _$FavoriteStore;

abstract class _FavoriteStoreBase with Store {
  final IUCGetFavoriteCharacters getFavoriteCharacters;
  final IUCGetFavoriteLocations getFavoriteLocations;
  final IUCGetMultipleCharacters getMultipleCharacters;
  final IUCGetMultipleLocations getMultipleLocations;
  final IUCGetFavoriteEpisodes getFavoriteEpisodes;
  final IUCGetMultipleEpisodes getMultipleEpisodes;

  _FavoriteStoreBase(
    this.getFavoriteCharacters,
    this.getMultipleCharacters,
    this.getFavoriteLocations,
    this.getMultipleLocations,
    this.getFavoriteEpisodes,
    this.getMultipleEpisodes,
  );

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  List<String> favoritesIdList = [];
  @action
  setfavoritesIdList(List<String> value) => favoritesIdList = value;

  @observable
  List<FavoriteItem> favoriteItemsList = [];
  @action
  setFavoriteItemsList(List<FavoriteItem> value) => favoriteItemsList = value;

  @action
  Future<void> startStore(String favoriteType) async {
    setPageState(LoadingState());
    switch (favoriteType) {
      case 'characters':
        final response = await getFavoriteCharacters();
        await response.fold(
          (l) async {
            setPageState(ErrorState());
          },
          (r) async {
            setfavoritesIdList(r);
            final response = await getMultipleCharacters(
                r.map((e) => int.parse(e)).toList());
            await response.fold(
              (l) async {
                setPageState(ErrorState());
              },
              (r) async {
                setFavoriteItemsList(r
                    .map((e) => FavoriteItem(
                          title: e.name ?? '',
                          info1: "Origin: ${e.origin?.name ?? ''}",
                          info2: "Species: ${e.species ?? ''}",
                          image: e.image ?? '',
                        ))
                    .toList());
              },
            );
          },
        );
        break;
      case 'locations':
        final response = await getFavoriteLocations();
        await response.fold(
          (l) async {
            setPageState(ErrorState());
          },
          (r) async {
            setfavoritesIdList(r);
            final response =
                await getMultipleLocations(r.map((e) => int.parse(e)).toList());
            await response.fold(
              (l) async {
                setPageState(ErrorState());
              },
              (r) async {
                setFavoriteItemsList(r
                    .map((e) => FavoriteItem(
                          title: e.name ?? '',
                          info1: "Type: ${e.type ?? ''}",
                          info2: "Characters: ${e.residents?.length ?? '0'}",
                          image: '',
                          icon: const Icon(CupertinoIcons.placemark, size: 50),
                        ))
                    .toList());
              },
            );
          },
        );
        break;
      case 'episodes':
        final response = await getFavoriteEpisodes();
        await response.fold(
          (l) async {
            setPageState(ErrorState());
          },
          (r) async {
            setfavoritesIdList(r);
            final response =
                await getMultipleEpisodes(r.map((e) => int.parse(e)).toList());
            await response.fold(
              (l) async {
                setPageState(ErrorState());
              },
              (r) async {
                setFavoriteItemsList(r
                    .map((e) => FavoriteItem(
                          title: "${e.episode} - ${e.name}",
                          info1: "Air date: ${e.airDate ?? ''}",
                          info2: "Characters: ${e.characters?.length ?? '0'}",
                          image: '',
                          icon: const Icon(CupertinoIcons.placemark, size: 50),
                        ))
                    .toList());
              },
            );
          },
        );
        break;
      default:
    }
    if (pageState is LoadingState) setPageState(SuccessState());
  }
}
