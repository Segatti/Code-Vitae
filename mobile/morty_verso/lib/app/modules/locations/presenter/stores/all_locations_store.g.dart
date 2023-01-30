// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AllLocationsStore on _AllLocationsStoreBase, Store {
  Computed<bool>? _$prevButtonComputed;

  @override
  bool get prevButton =>
      (_$prevButtonComputed ??= Computed<bool>(() => super.prevButton,
              name: '_AllLocationsStoreBase.prevButton'))
          .value;
  Computed<bool>? _$nextButtonComputed;

  @override
  bool get nextButton =>
      (_$nextButtonComputed ??= Computed<bool>(() => super.nextButton,
              name: '_AllLocationsStoreBase.nextButton'))
          .value;

  late final _$pageStateAtom =
      Atom(name: '_AllLocationsStoreBase.pageState', context: context);

  @override
  PageState get pageState {
    _$pageStateAtom.reportRead();
    return super.pageState;
  }

  @override
  set pageState(PageState value) {
    _$pageStateAtom.reportWrite(value, super.pageState, () {
      super.pageState = value;
    });
  }

  late final _$locationsAtom =
      Atom(name: '_AllLocationsStoreBase.locations', context: context);

  @override
  Locations get locations {
    _$locationsAtom.reportRead();
    return super.locations;
  }

  @override
  set locations(Locations value) {
    _$locationsAtom.reportWrite(value, super.locations, () {
      super.locations = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_AllLocationsStoreBase.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$favoriteLocationsIdListAtom = Atom(
      name: '_AllLocationsStoreBase.favoriteLocationsIdList', context: context);

  @override
  List<String> get favoriteLocationsIdList {
    _$favoriteLocationsIdListAtom.reportRead();
    return super.favoriteLocationsIdList;
  }

  @override
  set favoriteLocationsIdList(List<String> value) {
    _$favoriteLocationsIdListAtom
        .reportWrite(value, super.favoriteLocationsIdList, () {
      super.favoriteLocationsIdList = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_AllLocationsStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$getLocationsAsyncAction =
      AsyncAction('_AllLocationsStoreBase.getLocations', context: context);

  @override
  Future<void> getLocations() {
    return _$getLocationsAsyncAction.run(() => super.getLocations());
  }

  late final _$getFavoriteLocationsLocalStorageAsyncAction = AsyncAction(
      '_AllLocationsStoreBase.getFavoriteLocationsLocalStorage',
      context: context);

  @override
  Future<void> getFavoriteLocationsLocalStorage() {
    return _$getFavoriteLocationsLocalStorageAsyncAction
        .run(() => super.getFavoriteLocationsLocalStorage());
  }

  late final _$saveFavoriteLocationsLocalStorageAsyncAction = AsyncAction(
      '_AllLocationsStoreBase.saveFavoriteLocationsLocalStorage',
      context: context);

  @override
  Future<void> saveFavoriteLocationsLocalStorage() {
    return _$saveFavoriteLocationsLocalStorageAsyncAction
        .run(() => super.saveFavoriteLocationsLocalStorage());
  }

  late final _$_AllLocationsStoreBaseActionController =
      ActionController(name: '_AllLocationsStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_AllLocationsStoreBaseActionController.startAction(
        name: '_AllLocationsStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_AllLocationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLocations(Locations value) {
    final _$actionInfo = _$_AllLocationsStoreBaseActionController.startAction(
        name: '_AllLocationsStoreBase.setLocations');
    try {
      return super.setLocations(value);
    } finally {
      _$_AllLocationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentPage(int value) {
    final _$actionInfo = _$_AllLocationsStoreBaseActionController.startAction(
        name: '_AllLocationsStoreBase.setCurrentPage');
    try {
      return super.setCurrentPage(value);
    } finally {
      _$_AllLocationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteLocationsIdList(List<String> value) {
    final _$actionInfo = _$_AllLocationsStoreBaseActionController.startAction(
        name: '_AllLocationsStoreBase.setFavoriteLocationsIdList');
    try {
      return super.setFavoriteLocationsIdList(value);
    } finally {
      _$_AllLocationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
locations: ${locations},
currentPage: ${currentPage},
favoriteLocationsIdList: ${favoriteLocationsIdList},
prevButton: ${prevButton},
nextButton: ${nextButton}
    ''';
  }
}
