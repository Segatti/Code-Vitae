// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_navigation_bar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BottomNavigationBarStore on _BottomNavigationBarStoreBase, Store {
  late final _$currentIndexAtom = Atom(
      name: '_BottomNavigationBarStoreBase.currentIndex', context: context);

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_BottomNavigationBarStoreBase.startStore', context: context);

  @override
  Future<void> startStore(int initialValue) {
    return _$startStoreAsyncAction.run(() => super.startStore(initialValue));
  }

  late final _$_BottomNavigationBarStoreBaseActionController =
      ActionController(name: '_BottomNavigationBarStoreBase', context: context);

  @override
  dynamic setCurrentIndex(int value) {
    final _$actionInfo = _$_BottomNavigationBarStoreBaseActionController
        .startAction(name: '_BottomNavigationBarStoreBase.setCurrentIndex');
    try {
      return super.setCurrentIndex(value);
    } finally {
      _$_BottomNavigationBarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex}
    ''';
  }
}
