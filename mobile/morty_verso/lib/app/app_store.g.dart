// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStoreBase, Store {
  late final _$themeIsDarkAtom =
      Atom(name: '_AppStoreBase.themeIsDark', context: context);

  @override
  bool get themeIsDark {
    _$themeIsDarkAtom.reportRead();
    return super.themeIsDark;
  }

  @override
  set themeIsDark(bool value) {
    _$themeIsDarkAtom.reportWrite(value, super.themeIsDark, () {
      super.themeIsDark = value;
    });
  }

  late final _$setThemeIsDarkAsyncAction =
      AsyncAction('_AppStoreBase.setThemeIsDark', context: context);

  @override
  Future setThemeIsDark(bool value) {
    return _$setThemeIsDarkAsyncAction.run(() => super.setThemeIsDark(value));
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_AppStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  @override
  String toString() {
    return '''
themeIsDark: ${themeIsDark}
    ''';
  }
}
