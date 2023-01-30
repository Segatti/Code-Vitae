// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_modular/flutter_modular.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_favorite_characters.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  final UCGetFavoriteCharacters getFavoriteCharacters;

  _ProfileStoreBase(this.getFavoriteCharacters);

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
}
