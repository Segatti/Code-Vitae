// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_episodes_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AllEpisodesStore on _AllEpisodesStoreBase, Store {
  Computed<bool>? _$prevButtonComputed;

  @override
  bool get prevButton =>
      (_$prevButtonComputed ??= Computed<bool>(() => super.prevButton,
              name: '_AllEpisodesStoreBase.prevButton'))
          .value;
  Computed<bool>? _$nextButtonComputed;

  @override
  bool get nextButton =>
      (_$nextButtonComputed ??= Computed<bool>(() => super.nextButton,
              name: '_AllEpisodesStoreBase.nextButton'))
          .value;

  late final _$pageStateAtom =
      Atom(name: '_AllEpisodesStoreBase.pageState', context: context);

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

  late final _$episodesAtom =
      Atom(name: '_AllEpisodesStoreBase.episodes', context: context);

  @override
  Episodes get episodes {
    _$episodesAtom.reportRead();
    return super.episodes;
  }

  @override
  set episodes(Episodes value) {
    _$episodesAtom.reportWrite(value, super.episodes, () {
      super.episodes = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_AllEpisodesStoreBase.currentPage', context: context);

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

  late final _$favoriteEpisodesIdListAtom = Atom(
      name: '_AllEpisodesStoreBase.favoriteEpisodesIdList', context: context);

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
      AsyncAction('_AllEpisodesStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$getEpisodesAsyncAction =
      AsyncAction('_AllEpisodesStoreBase.getEpisodes', context: context);

  @override
  Future<void> getEpisodes() {
    return _$getEpisodesAsyncAction.run(() => super.getEpisodes());
  }

  late final _$getFavoriteEpisodesLocalStorageAsyncAction = AsyncAction(
      '_AllEpisodesStoreBase.getFavoriteEpisodesLocalStorage',
      context: context);

  @override
  Future<void> getFavoriteEpisodesLocalStorage() {
    return _$getFavoriteEpisodesLocalStorageAsyncAction
        .run(() => super.getFavoriteEpisodesLocalStorage());
  }

  late final _$saveFavoriteEpisodesLocalStorageAsyncAction = AsyncAction(
      '_AllEpisodesStoreBase.saveFavoriteEpisodesLocalStorage',
      context: context);

  @override
  Future<void> saveFavoriteEpisodesLocalStorage() {
    return _$saveFavoriteEpisodesLocalStorageAsyncAction
        .run(() => super.saveFavoriteEpisodesLocalStorage());
  }

  late final _$_AllEpisodesStoreBaseActionController =
      ActionController(name: '_AllEpisodesStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_AllEpisodesStoreBaseActionController.startAction(
        name: '_AllEpisodesStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_AllEpisodesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEpisodes(Episodes value) {
    final _$actionInfo = _$_AllEpisodesStoreBaseActionController.startAction(
        name: '_AllEpisodesStoreBase.setEpisodes');
    try {
      return super.setEpisodes(value);
    } finally {
      _$_AllEpisodesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentPage(int value) {
    final _$actionInfo = _$_AllEpisodesStoreBaseActionController.startAction(
        name: '_AllEpisodesStoreBase.setCurrentPage');
    try {
      return super.setCurrentPage(value);
    } finally {
      _$_AllEpisodesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavoriteEpisodesIdList(List<String> value) {
    final _$actionInfo = _$_AllEpisodesStoreBaseActionController.startAction(
        name: '_AllEpisodesStoreBase.setFavoriteEpisodesIdList');
    try {
      return super.setFavoriteEpisodesIdList(value);
    } finally {
      _$_AllEpisodesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
episodes: ${episodes},
currentPage: ${currentPage},
favoriteEpisodesIdList: ${favoriteEpisodesIdList},
prevButton: ${prevButton},
nextButton: ${nextButton}
    ''';
  }
}
