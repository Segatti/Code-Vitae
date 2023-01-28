// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: '_ProfileStoreBase.pageState', context: context);

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

  late final _$favoriteCharactersIdListAtom = Atom(
      name: '_ProfileStoreBase.favoriteCharactersIdList', context: context);

  @override
  List<String> get favoriteCharactersIdList {
    _$favoriteCharactersIdListAtom.reportRead();
    return super.favoriteCharactersIdList;
  }

  @override
  set favoriteCharactersIdList(List<String> value) {
    _$favoriteCharactersIdListAtom
        .reportWrite(value, super.favoriteCharactersIdList, () {
      super.favoriteCharactersIdList = value;
    });
  }

  late final _$favoritePlanetsIdListAtom =
      Atom(name: '_ProfileStoreBase.favoritePlanetsIdList', context: context);

  @override
  List<String> get favoritePlanetsIdList {
    _$favoritePlanetsIdListAtom.reportRead();
    return super.favoritePlanetsIdList;
  }

  @override
  set favoritePlanetsIdList(List<String> value) {
    _$favoritePlanetsIdListAtom.reportWrite(value, super.favoritePlanetsIdList,
        () {
      super.favoritePlanetsIdList = value;
    });
  }

  late final _$favoriteEpisodesIdListAtom =
      Atom(name: '_ProfileStoreBase.favoriteEpisodesIdList', context: context);

  @override
  List<String> get favoriteEpisodesIdList {
    _$favoriteEpisodesIdListAtom.reportRead();
    return super.favoriteEpisodesIdList;
  }

  @override
  set favoriteEpisodesIdList(List<String> value) {
    _$favoriteEpisodesIdListAtom
        .reportWrite(value, super.favoriteEpisodesIdList, () {
      super.favoriteEpisodesIdList = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_ProfileStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$getFavoriteCharactersLocalStorageAsyncAction = AsyncAction(
      '_ProfileStoreBase.getFavoriteCharactersLocalStorage',
      context: context);

  @override
  Future<void> getFavoriteCharactersLocalStorage() {
    return _$getFavoriteCharactersLocalStorageAsyncAction
        .run(() => super.getFavoriteCharactersLocalStorage());
  }

  late final _$_ProfileStoreBaseActionController =
      ActionController(name: '_ProfileStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteCharactersIdList(List<String> value) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setFavoriteCharactersIdList');
    try {
      return super.setFavoriteCharactersIdList(value);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoritePlanetsIdList(List<String> value) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setFavoritePlanetsIdList');
    try {
      return super.setFavoritePlanetsIdList(value);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteEpisodesIdList(List<String> value) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setFavoriteEpisodesIdList');
    try {
      return super.setFavoriteEpisodesIdList(value);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
favoriteCharactersIdList: ${favoriteCharactersIdList},
favoritePlanetsIdList: ${favoritePlanetsIdList},
favoriteEpisodesIdList: ${favoriteEpisodesIdList}
    ''';
  }
}
