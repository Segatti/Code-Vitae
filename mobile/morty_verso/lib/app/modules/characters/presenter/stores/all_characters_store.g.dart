// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_characters_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AllCharactersStore on _AllCharactersStoreBase, Store {
  Computed<bool>? _$prevButtonComputed;

  @override
  bool get prevButton =>
      (_$prevButtonComputed ??= Computed<bool>(() => super.prevButton,
              name: '_AllCharactersStoreBase.prevButton'))
          .value;
  Computed<bool>? _$nextButtonComputed;

  @override
  bool get nextButton =>
      (_$nextButtonComputed ??= Computed<bool>(() => super.nextButton,
              name: '_AllCharactersStoreBase.nextButton'))
          .value;

  late final _$pageStateAtom =
      Atom(name: '_AllCharactersStoreBase.pageState', context: context);

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

  late final _$charactersAtom =
      Atom(name: '_AllCharactersStoreBase.characters', context: context);

  @override
  Characters get characters {
    _$charactersAtom.reportRead();
    return super.characters;
  }

  @override
  set characters(Characters value) {
    _$charactersAtom.reportWrite(value, super.characters, () {
      super.characters = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_AllCharactersStoreBase.currentPage', context: context);

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

  late final _$favoriteCharactersIdListAtom = Atom(
      name: '_AllCharactersStoreBase.favoriteCharactersIdList',
      context: context);

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
      AsyncAction('_AllCharactersStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$getCharactersAsyncAction =
      AsyncAction('_AllCharactersStoreBase.getCharacters', context: context);

  @override
  Future<void> getCharacters() {
    return _$getCharactersAsyncAction.run(() => super.getCharacters());
  }

  late final _$getFavoriteCharactersLocalStorageAsyncAction = AsyncAction(
      '_AllCharactersStoreBase.getFavoriteCharactersLocalStorage',
      context: context);

  @override
  Future<void> getFavoriteCharactersLocalStorage() {
    return _$getFavoriteCharactersLocalStorageAsyncAction
        .run(() => super.getFavoriteCharactersLocalStorage());
  }

  late final _$saveFavoriteCharactersLocalStorageAsyncAction = AsyncAction(
      '_AllCharactersStoreBase.saveFavoriteCharactersLocalStorage',
      context: context);

  @override
  Future<void> saveFavoriteCharactersLocalStorage() {
    return _$saveFavoriteCharactersLocalStorageAsyncAction
        .run(() => super.saveFavoriteCharactersLocalStorage());
  }

  late final _$_AllCharactersStoreBaseActionController =
      ActionController(name: '_AllCharactersStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_AllCharactersStoreBaseActionController.startAction(
        name: '_AllCharactersStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_AllCharactersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCharacters(Characters value) {
    final _$actionInfo = _$_AllCharactersStoreBaseActionController.startAction(
        name: '_AllCharactersStoreBase.setCharacters');
    try {
      return super.setCharacters(value);
    } finally {
      _$_AllCharactersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentPage(int value) {
    final _$actionInfo = _$_AllCharactersStoreBaseActionController.startAction(
        name: '_AllCharactersStoreBase.setCurrentPage');
    try {
      return super.setCurrentPage(value);
    } finally {
      _$_AllCharactersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteCharactersIdList(List<String> value) {
    final _$actionInfo = _$_AllCharactersStoreBaseActionController.startAction(
        name: '_AllCharactersStoreBase.setFavoriteCharactersIdList');
    try {
      return super.setFavoriteCharactersIdList(value);
    } finally {
      _$_AllCharactersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
characters: ${characters},
currentPage: ${currentPage},
favoriteCharactersIdList: ${favoriteCharactersIdList},
prevButton: ${prevButton},
nextButton: ${nextButton}
    ''';
  }
}
