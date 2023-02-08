// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStoreBase, Store {
  Computed<bool>? _$themeIsDarkComputed;

  @override
  bool get themeIsDark =>
      (_$themeIsDarkComputed ??= Computed<bool>(() => super.themeIsDark,
              name: '_AppStoreBase.themeIsDark'))
          .value;

  late final _$themeDataAtom =
      Atom(name: '_AppStoreBase.themeData', context: context);

  @override
  CupertinoThemeData get themeData {
    _$themeDataAtom.reportRead();
    return super.themeData;
  }

  @override
  set themeData(CupertinoThemeData value) {
    _$themeDataAtom.reportWrite(value, super.themeData, () {
      super.themeData = value;
    });
  }

  late final _$getThemeStorageAsyncAction =
      AsyncAction('_AppStoreBase.getThemeStorage', context: context);

  @override
  Future<void> getThemeStorage() {
    return _$getThemeStorageAsyncAction.run(() => super.getThemeStorage());
  }

  late final _$toggleThemeStorageAsyncAction =
      AsyncAction('_AppStoreBase.toggleThemeStorage', context: context);

  @override
  Future<void> toggleThemeStorage() {
    return _$toggleThemeStorageAsyncAction
        .run(() => super.toggleThemeStorage());
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_AppStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$_AppStoreBaseActionController =
      ActionController(name: '_AppStoreBase', context: context);

  @override
  dynamic setThemeData(CupertinoThemeData value) {
    final _$actionInfo = _$_AppStoreBaseActionController.startAction(
        name: '_AppStoreBase.setThemeData');
    try {
      return super.setThemeData(value);
    } finally {
      _$_AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
themeData: ${themeData},
themeIsDark: ${themeIsDark}
    ''';
  }
}
