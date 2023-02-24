// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStoreBase, Store {
  late final _$itemFocusAtom =
      Atom(name: '_MainStoreBase.itemFocus', context: context);

  @override
  int? get itemFocus {
    _$itemFocusAtom.reportRead();
    return super.itemFocus;
  }

  @override
  set itemFocus(int? value) {
    _$itemFocusAtom.reportWrite(value, super.itemFocus, () {
      super.itemFocus = value;
    });
  }

  late final _$_MainStoreBaseActionController =
      ActionController(name: '_MainStoreBase', context: context);

  @override
  dynamic setItemFocus(int value) {
    final _$actionInfo = _$_MainStoreBaseActionController.startAction(
        name: '_MainStoreBase.setItemFocus');
    try {
      return super.setItemFocus(value);
    } finally {
      _$_MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itemFocus: ${itemFocus}
    ''';
  }
}
