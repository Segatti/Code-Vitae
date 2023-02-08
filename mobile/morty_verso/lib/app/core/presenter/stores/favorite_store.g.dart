// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoriteStore on _FavoriteStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: '_FavoriteStoreBase.pageState', context: context);

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

  late final _$favoritesIdListAtom =
      Atom(name: '_FavoriteStoreBase.favoritesIdList', context: context);

  @override
  List<String> get favoritesIdList {
    _$favoritesIdListAtom.reportRead();
    return super.favoritesIdList;
  }

  @override
  set favoritesIdList(List<String> value) {
    _$favoritesIdListAtom.reportWrite(value, super.favoritesIdList, () {
      super.favoritesIdList = value;
    });
  }

  late final _$favoriteItemsListAtom =
      Atom(name: '_FavoriteStoreBase.favoriteItemsList', context: context);

  @override
  List<FavoriteItem> get favoriteItemsList {
    _$favoriteItemsListAtom.reportRead();
    return super.favoriteItemsList;
  }

  @override
  set favoriteItemsList(List<FavoriteItem> value) {
    _$favoriteItemsListAtom.reportWrite(value, super.favoriteItemsList, () {
      super.favoriteItemsList = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_FavoriteStoreBase.startStore', context: context);

  @override
  Future<void> startStore(String favoriteType) {
    return _$startStoreAsyncAction.run(() => super.startStore(favoriteType));
  }

  late final _$_FavoriteStoreBaseActionController =
      ActionController(name: '_FavoriteStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_FavoriteStoreBaseActionController.startAction(
        name: '_FavoriteStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_FavoriteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setfavoritesIdList(List<String> value) {
    final _$actionInfo = _$_FavoriteStoreBaseActionController.startAction(
        name: '_FavoriteStoreBase.setfavoritesIdList');
    try {
      return super.setfavoritesIdList(value);
    } finally {
      _$_FavoriteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteItemsList(List<FavoriteItem> value) {
    final _$actionInfo = _$_FavoriteStoreBaseActionController.startAction(
        name: '_FavoriteStoreBase.setFavoriteItemsList');
    try {
      return super.setFavoriteItemsList(value);
    } finally {
      _$_FavoriteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
favoritesIdList: ${favoritesIdList},
favoriteItemsList: ${favoriteItemsList}
    ''';
  }
}
