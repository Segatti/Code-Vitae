// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_modular/flutter_modular.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_favorite_characters.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  final UCGetFavoriteCharacters getFavoriteCharacters;

  _HomeStoreBase(this.getFavoriteCharacters);

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  List<String> favoriteCharactersIdList = [];
  @action
  setFavoriteCharactersIdList(List<String> value) =>
      favoriteCharactersIdList = value;

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
    final result = await getFavoriteCharacters('favorite_characters');
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
