// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../domain/entities/characters.dart';
import '../../domain/usecases/get_all_characters.dart';
import '../../domain/usecases/get_favorite_characters.dart';
import '../../domain/usecases/set_favorite_characters.dart';

part 'all_characters_store.g.dart';

class AllCharactersStore = _AllCharactersStoreBase with _$AllCharactersStore;

abstract class _AllCharactersStoreBase with Store {
  final UCGetAllCharacters getAllCharacters;
  final UCGetFavoriteCharacters getFavoriteCharacters;
  final UCSetFavoriteCharacters setFavoriteCharacters;

  _AllCharactersStoreBase(
    this.getAllCharacters,
    this.getFavoriteCharacters,
    this.setFavoriteCharacters,
  );

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @action
  Future<void> startStore() async {
    setPageState(LoadingState());
    await getCharacters();
    await getFavoriteCharactersLocalStorage();
    if (pageState is LoadingState) setPageState(SuccessState());
  }

  @observable
  Characters characters = const Characters();
  @action
  setCharacters(Characters value) => characters = value;

  @observable
  int currentPage = 1;
  @action
  setCurrentPage(int value) => currentPage = value;

  @computed
  bool get prevButton => currentPage > 1 && characters.info?.prev != null;
  @computed
  bool get nextButton =>
      characters.info?.next != null &&
      currentPage < (characters.info?.pages ?? 0);

  @observable
  List<String> favoriteCharactersIdList = [];
  @action
  setFavoriteCharactersIdList(List<String> value) =>
      favoriteCharactersIdList = value;

  @action
  Future<void> getCharacters() async {
    final response = await getAllCharacters(currentPage);
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setCharacters(r);
      },
    );
  }

  @action
  Future<void> getFavoriteCharactersLocalStorage() async {
    final response = await getFavoriteCharacters('favorite_characters');
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setFavoriteCharactersIdList(r);
      },
    );
  }

  @action
  Future<void> saveFavoriteCharactersLocalStorage() async {
    setPageState(LoadingState());
    final response = await setFavoriteCharacters(
      'favorite_characters',
      favoriteCharactersIdList,
    );
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setPageState(SuccessState());
      },
    );
  }
}
