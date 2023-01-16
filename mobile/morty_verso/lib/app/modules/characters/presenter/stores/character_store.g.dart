// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharacterStore on _CharacterStoreBase, Store {
  late final _$carregandoAtom =
      Atom(name: '_CharacterStoreBase.carregando', context: context);

  @override
  bool get carregando {
    _$carregandoAtom.reportRead();
    return super.carregando;
  }

  @override
  set carregando(bool value) {
    _$carregandoAtom.reportWrite(value, super.carregando, () {
      super.carregando = value;
    });
  }

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

  late final _$_CharacterStoreBaseActionController =
      ActionController(name: '_CharacterStoreBase', context: context);

  @override
  dynamic setCarregando(bool value) {
    final _$actionInfo = _$_CharacterStoreBaseActionController.startAction(
        name: '_CharacterStoreBase.setCarregando');
    try {
      return super.setCarregando(value);
    } finally {
      _$_CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
carregando: ${carregando},
pageState: ${pageState}
    ''';
  }
}
