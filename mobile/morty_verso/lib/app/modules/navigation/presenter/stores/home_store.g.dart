// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: '_HomeStoreBase.pageState', context: context);

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

  late final _$favoriteCharactersIdListAtom =
      Atom(name: '_HomeStoreBase.favoriteCharactersIdList', context: context);

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

  late final _$startStoreAsyncAction =
      AsyncAction('_HomeStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$getFavoriteCharactersLocalStorageAsyncAction = AsyncAction(
      '_HomeStoreBase.getFavoriteCharactersLocalStorage',
      context: context);

  @override
  Future<void> getFavoriteCharactersLocalStorage() {
    return _$getFavoriteCharactersLocalStorageAsyncAction
        .run(() => super.getFavoriteCharactersLocalStorage());
  }

  late final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteCharactersIdList(List<String> value) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.setFavoriteCharactersIdList');
    try {
      return super.setFavoriteCharactersIdList(value);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
favoriteCharactersIdList: ${favoriteCharactersIdList}
    ''';
  }
}
