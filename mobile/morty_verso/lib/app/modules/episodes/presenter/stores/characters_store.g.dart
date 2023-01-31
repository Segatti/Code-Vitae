// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharactersStore on _CharactersStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: '_CharactersStoreBase.pageState', context: context);

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
      Atom(name: '_CharactersStoreBase.characters', context: context);

  @override
  List<Character> get characters {
    _$charactersAtom.reportRead();
    return super.characters;
  }

  @override
  set characters(List<Character> value) {
    _$charactersAtom.reportWrite(value, super.characters, () {
      super.characters = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_CharactersStoreBase.startStore', context: context);

  @override
  Future<void> startStore(List<int> ids) {
    return _$startStoreAsyncAction.run(() => super.startStore(ids));
  }

  late final _$getCharactersAsyncAction =
      AsyncAction('_CharactersStoreBase.getCharacters', context: context);

  @override
  Future<void> getCharacters(List<int> ids) {
    return _$getCharactersAsyncAction.run(() => super.getCharacters(ids));
  }

  late final _$_CharactersStoreBaseActionController =
      ActionController(name: '_CharactersStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_CharactersStoreBaseActionController.startAction(
        name: '_CharactersStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_CharactersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCharacters(List<Character> value) {
    final _$actionInfo = _$_CharactersStoreBaseActionController.startAction(
        name: '_CharactersStoreBase.setCharacters');
    try {
      return super.setCharacters(value);
    } finally {
      _$_CharactersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
characters: ${characters}
    ''';
  }
}
