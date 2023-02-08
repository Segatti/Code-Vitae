// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharacterStore on _CharacterStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: '_CharacterStoreBase.pageState', context: context);

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

  late final _$characterAtom =
      Atom(name: '_CharacterStoreBase.character', context: context);

  @override
  Character get character {
    _$characterAtom.reportRead();
    return super.character;
  }

  @override
  set character(Character value) {
    _$characterAtom.reportWrite(value, super.character, () {
      super.character = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_CharacterStoreBase.startStore', context: context);

  @override
  Future<void> startStore(int id) {
    return _$startStoreAsyncAction.run(() => super.startStore(id));
  }

  late final _$getCharacterAsyncAction =
      AsyncAction('_CharacterStoreBase.getCharacter', context: context);

  @override
  Future<void> getCharacter(int id) {
    return _$getCharacterAsyncAction.run(() => super.getCharacter(id));
  }

  late final _$_CharacterStoreBaseActionController =
      ActionController(name: '_CharacterStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_CharacterStoreBaseActionController.startAction(
        name: '_CharacterStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCharacter(Character value) {
    final _$actionInfo = _$_CharacterStoreBaseActionController.startAction(
        name: '_CharacterStoreBase.setCharacter');
    try {
      return super.setCharacter(value);
    } finally {
      _$_CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
character: ${character}
    ''';
  }
}
