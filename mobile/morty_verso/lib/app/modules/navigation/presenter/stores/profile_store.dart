// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_modular/flutter_modular.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../../characters/domain/usecases/get_favorite_characters.dart';
import '../../../episodes/domain/usecases/get_favorite_episodes.dart';
import '../../../locations/domain/usecases/get_favorite_locations.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  final UCGetFavoriteCharacters getFavoriteCharacters;
  final UCGetFavoriteLocations getFavoriteLocations;
  final UCGetFavoriteEpisodes getFavoriteEpisodes;

  _ProfileStoreBase(
    this.getFavoriteCharacters,
    this.getFavoriteLocations,
    this.getFavoriteEpisodes,
  );

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  List<String> favoriteCharactersIdList = [];
  @action
  setFavoriteCharactersIdList(List<String> value) =>
      favoriteCharactersIdList = value;

  @observable
  List<String> favoriteLocationsIdList = [];
  @action
  setFavoriteLocationsIdList(List<String> value) =>
      favoriteLocationsIdList = value;

  @observable
  List<String> favoriteEpisodesIdList = [];
  @action
  setFavoriteEpisodesIdList(List<String> value) =>
      favoriteEpisodesIdList = value;

  @action
  Future<void> startStore() async {
    LocalStorage localStorage = Modular.get<LocalStorage>();
    await localStorage.ready;
    setPageState(LoadingState());
    await getFavoriteCharactersLocalStorage();
    await getFavoriteLocationsLocalStorage();
    await getFavoriteEpisodesLocalStorage();
    setPageState(SuccessState());
  }

  @action
  Future<void> getFavoriteCharactersLocalStorage() async {
    final result = await getFavoriteCharacters();
    await result.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setFavoriteCharactersIdList(r);
      },
    );
  }

  @action
  Future<void> getFavoriteLocationsLocalStorage() async {
    final result = await getFavoriteLocations();
    await result.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setFavoriteLocationsIdList(r);
      },
    );
  }

  @action
  Future<void> getFavoriteEpisodesLocalStorage() async {
    final result = await getFavoriteEpisodes();
    await result.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setFavoriteEpisodesIdList(r);
      },
    );
  }
}
