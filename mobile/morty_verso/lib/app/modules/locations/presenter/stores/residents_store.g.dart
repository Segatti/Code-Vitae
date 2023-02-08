// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residents_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResidentsStore on _ResidentsStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: '_ResidentsStoreBase.pageState', context: context);

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

  late final _$residentsAtom =
      Atom(name: '_ResidentsStoreBase.residents', context: context);

  @override
  List<Character> get residents {
    _$residentsAtom.reportRead();
    return super.residents;
  }

  @override
  set residents(List<Character> value) {
    _$residentsAtom.reportWrite(value, super.residents, () {
      super.residents = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_ResidentsStoreBase.startStore', context: context);

  @override
  Future<void> startStore(List<int> ids) {
    return _$startStoreAsyncAction.run(() => super.startStore(ids));
  }

  late final _$getResidentsAsyncAction =
      AsyncAction('_ResidentsStoreBase.getResidents', context: context);

  @override
  Future<void> getResidents(List<int> ids) {
    return _$getResidentsAsyncAction.run(() => super.getResidents(ids));
  }

  late final _$_ResidentsStoreBaseActionController =
      ActionController(name: '_ResidentsStoreBase', context: context);

  @override
  dynamic setPageState(PageState value) {
    final _$actionInfo = _$_ResidentsStoreBaseActionController.startAction(
        name: '_ResidentsStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$_ResidentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setResidents(List<Character> value) {
    final _$actionInfo = _$_ResidentsStoreBaseActionController.startAction(
        name: '_ResidentsStoreBase.setResidents');
    try {
      return super.setResidents(value);
    } finally {
      _$_ResidentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
residents: ${residents}
    ''';
  }
}
