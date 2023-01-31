// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_preview_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PdfPreviewStore on _PdfPreviewStoreBase, Store {
  late final _$charactersListAtom =
      Atom(name: '_PdfPreviewStoreBase.charactersList', context: context);

  @override
  List<Character> get charactersList {
    _$charactersListAtom.reportRead();
    return super.charactersList;
  }

  @override
  set charactersList(List<Character> value) {
    _$charactersListAtom.reportWrite(value, super.charactersList, () {
      super.charactersList = value;
    });
  }

  late final _$locationsListAtom =
      Atom(name: '_PdfPreviewStoreBase.locationsList', context: context);

  @override
  List<Location> get locationsList {
    _$locationsListAtom.reportRead();
    return super.locationsList;
  }

  @override
  set locationsList(List<Location> value) {
    _$locationsListAtom.reportWrite(value, super.locationsList, () {
      super.locationsList = value;
    });
  }

  late final _$episodesListAtom =
      Atom(name: '_PdfPreviewStoreBase.episodesList', context: context);

  @override
  List<Episode> get episodesList {
    _$episodesListAtom.reportRead();
    return super.episodesList;
  }

  @override
  set episodesList(List<Episode> value) {
    _$episodesListAtom.reportWrite(value, super.episodesList, () {
      super.episodesList = value;
    });
  }

  late final _$pageStateAtom =
      Atom(name: '_PdfPreviewStoreBase.pageState', context: context);

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

  late final _$pdfAtom =
      Atom(name: '_PdfPreviewStoreBase.pdf', context: context);

  @override
  Uint8List get pdf {
    _$pdfAtom.reportRead();
    return super.pdf;
  }

  @override
  set pdf(Uint8List value) {
    _$pdfAtom.reportWrite(value, super.pdf, () {
      super.pdf = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_PdfPreviewStoreBase.startStore', context: context);

  @override
  Future<void> startStore(List<String> charactersIdList,
      List<String> locationsIdList, List<String> episodesIdList) {
    return _$startStoreAsyncAction.run(() =>
        super.startStore(charactersIdList, locationsIdList, episodesIdList));
  }

  late final _$_PdfPreviewStoreBaseActionController =
      ActionController(name: '_PdfPreviewStoreBase', context: context);

  @override
  dynamic setCharactersList(List<Character> value) {
    final _$actionInfo = _$_PdfPreviewStoreBaseActionController.startAction(
        name: '_PdfPreviewStoreBase.setCharactersList');
    try {
      return super.setCharactersList(value);
    } finally {
      _$_PdfPreviewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLocationsList(List<Location> value) {
    final _$actionInfo = _$_PdfPreviewStoreBaseActionController.startAction(
        name: '_PdfPreviewStoreBase.setLocationsList');
    try {
      return super.setLocationsList(value);
    } finally {
      _$_PdfPreviewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEpisodesList(List<Episode> value) {
    final _$actionInfo = _$_PdfPreviewStoreBaseActionController.startAction(
        name: '_PdfPreviewStoreBase.setEpisodesList');
    try {
      return super.setEpisodesList(value);
    } finally {
      _$_PdfPreviewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_PdfPreviewStoreBaseActionController.startAction(
        name: '_PdfPreviewStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_PdfPreviewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPdf(Uint8List value) {
    final _$actionInfo = _$_PdfPreviewStoreBaseActionController.startAction(
        name: '_PdfPreviewStoreBase.setPdf');
    try {
      return super.setPdf(value);
    } finally {
      _$_PdfPreviewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
charactersList: ${charactersList},
locationsList: ${locationsList},
episodesList: ${episodesList},
pageState: ${pageState},
pdf: ${pdf}
    ''';
  }
}
