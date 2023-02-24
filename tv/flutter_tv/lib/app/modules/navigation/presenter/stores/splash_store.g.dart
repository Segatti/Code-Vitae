// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SplashStore on _SplashStoreBase, Store {
  late final _$userIsLoggedAtom =
      Atom(name: '_SplashStoreBase.userIsLogged', context: context);

  @override
  bool get userIsLogged {
    _$userIsLoggedAtom.reportRead();
    return super.userIsLogged;
  }

  @override
  set userIsLogged(bool value) {
    _$userIsLoggedAtom.reportWrite(value, super.userIsLogged, () {
      super.userIsLogged = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_SplashStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$_SplashStoreBaseActionController =
      ActionController(name: '_SplashStoreBase', context: context);

  @override
  dynamic setUserIsLogged(bool value) {
    final _$actionInfo = _$_SplashStoreBaseActionController.startAction(
        name: '_SplashStoreBase.setUserIsLogged');
    try {
      return super.setUserIsLogged(value);
    } finally {
      _$_SplashStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userIsLogged: ${userIsLogged}
    ''';
  }
}
