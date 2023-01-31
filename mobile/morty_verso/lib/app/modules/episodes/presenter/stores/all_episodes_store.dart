// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../domain/entities/episodes.dart';
import '../../domain/usecases/get_all_episodes.dart';
import '../../domain/usecases/get_favorite_episodes.dart';
import '../../domain/usecases/set_favorite_episodes.dart';

part 'all_episodes_store.g.dart';

class AllEpisodesStore = _AllEpisodesStoreBase with _$AllEpisodesStore;

abstract class _AllEpisodesStoreBase with Store {
  final UCGetAllEpisodes getAllEpisodes;
  final UCGetFavoriteEpisodes getFavoriteEpisodes;
  final UCSetFavoriteEpisodes setFavoriteEpisodes;

  _AllEpisodesStoreBase(
    this.getAllEpisodes,
    this.getFavoriteEpisodes,
    this.setFavoriteEpisodes,
  );

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @action
  Future<void> startStore() async {
    setPageState(LoadingState());
    await getEpisodes();
    await getFavoriteEpisodesLocalStorage();
    if (pageState is LoadingState) setPageState(SuccessState());
  }

  @observable
  Episodes episodes = const Episodes();
  @action
  setEpisodes(Episodes value) => episodes = value;

  @observable
  int currentPage = 1;
  @action
  setCurrentPage(int value) => currentPage = value;

  @computed
  bool get prevButton => currentPage > 1 && episodes.info?.prev != null;
  @computed
  bool get nextButton =>
      episodes.info?.next != null &&
      currentPage < (episodes.info?.pages ?? 0);

  @observable
  List<String> favoriteEpisodesIdList = [];
  @action
  setFavoriteEpisodesIdList(List<String> value) =>
      favoriteEpisodesIdList = value;

  @action
  Future<void> getEpisodes() async {
    final response = await getAllEpisodes(currentPage);
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setEpisodes(r);
      },
    );
  }

  @action
  Future<void> getFavoriteEpisodesLocalStorage() async {
    final response = await getFavoriteEpisodes();
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setFavoriteEpisodesIdList(r);
      },
    );
  }

  @action
  Future<void> saveFavoriteEpisodesLocalStorage() async {
    setPageState(LoadingState());
    final response = await setFavoriteEpisodes(
      'favorite_episodes',
      favoriteEpisodesIdList,
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
