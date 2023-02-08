// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../domain/entities/locations.dart';
import '../../domain/usecases/get_all_locations.dart';
import '../../domain/usecases/get_favorite_locations.dart';
import '../../domain/usecases/set_favorite_locations.dart';

part 'all_locations_store.g.dart';

class AllLocationsStore = _AllLocationsStoreBase with _$AllLocationsStore;

abstract class _AllLocationsStoreBase with Store {
  final UCGetAllLocations getAllLocations;
  final UCGetFavoriteLocations getFavoriteLocations;
  final UCSetFavoriteLocations setFavoriteLocations;

  _AllLocationsStoreBase(
    this.getAllLocations,
    this.getFavoriteLocations,
    this.setFavoriteLocations,
  );

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @action
  Future<void> startStore() async {
    setPageState(LoadingState());
    await getLocations();
    await getFavoriteLocationsLocalStorage();
    if (pageState is LoadingState) setPageState(SuccessState());
  }

  @observable
  Locations locations = const Locations();
  @action
  setLocations(Locations value) => locations = value;

  @observable
  int currentPage = 1;
  @action
  setCurrentPage(int value) => currentPage = value;

  @computed
  bool get prevButton => currentPage > 1 && locations.info?.prev != null;
  @computed
  bool get nextButton =>
      locations.info?.next != null &&
      currentPage < (locations.info?.pages ?? 0);

  @observable
  List<String> favoriteLocationsIdList = [];
  @action
  setFavoriteLocationsIdList(List<String> value) =>
      favoriteLocationsIdList = value;

  @action
  Future<void> getLocations() async {
    final response = await getAllLocations(currentPage);
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setLocations(r);
      },
    );
  }

  @action
  Future<void> getFavoriteLocationsLocalStorage() async {
    final response = await getFavoriteLocations();
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setFavoriteLocationsIdList(r);
      },
    );
  }

  @action
  Future<void> saveFavoriteLocationsLocalStorage() async {
    setPageState(LoadingState());
    final response = await setFavoriteLocations(
      'favorite_locations',
      favoriteLocationsIdList,
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
