// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStoreBase, Store {
  late final _$userIsLoggedAtom =
      Atom(name: '_LoginStoreBase.userIsLogged', context: context);

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

  late final _$focusEmailAtom =
      Atom(name: '_LoginStoreBase.focusEmail', context: context);

  @override
  bool get focusEmail {
    _$focusEmailAtom.reportRead();
    return super.focusEmail;
  }

  @override
  set focusEmail(bool value) {
    _$focusEmailAtom.reportWrite(value, super.focusEmail, () {
      super.focusEmail = value;
    });
  }

  late final _$focusSenhaAtom =
      Atom(name: '_LoginStoreBase.focusSenha', context: context);

  @override
  bool get focusSenha {
    _$focusSenhaAtom.reportRead();
    return super.focusSenha;
  }

  @override
  set focusSenha(bool value) {
    _$focusSenhaAtom.reportWrite(value, super.focusSenha, () {
      super.focusSenha = value;
    });
  }

  late final _$focusEntrarAtom =
      Atom(name: '_LoginStoreBase.focusEntrar', context: context);

  @override
  bool get focusEntrar {
    _$focusEntrarAtom.reportRead();
    return super.focusEntrar;
  }

  @override
  set focusEntrar(bool value) {
    _$focusEntrarAtom.reportWrite(value, super.focusEntrar, () {
      super.focusEntrar = value;
    });
  }

  late final _$focusCriarContaAtom =
      Atom(name: '_LoginStoreBase.focusCriarConta', context: context);

  @override
  bool get focusCriarConta {
    _$focusCriarContaAtom.reportRead();
    return super.focusCriarConta;
  }

  @override
  set focusCriarConta(bool value) {
    _$focusCriarContaAtom.reportWrite(value, super.focusCriarConta, () {
      super.focusCriarConta = value;
    });
  }

  late final _$focusRecuperarSenhaAtom =
      Atom(name: '_LoginStoreBase.focusRecuperarSenha', context: context);

  @override
  bool get focusRecuperarSenha {
    _$focusRecuperarSenhaAtom.reportRead();
    return super.focusRecuperarSenha;
  }

  @override
  set focusRecuperarSenha(bool value) {
    _$focusRecuperarSenhaAtom.reportWrite(value, super.focusRecuperarSenha, () {
      super.focusRecuperarSenha = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_LoginStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$loginAsyncAction =
      AsyncAction('_LoginStoreBase.login', context: context);

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$_LoginStoreBaseActionController =
      ActionController(name: '_LoginStoreBase', context: context);

  @override
  dynamic setUserIsLogged(bool value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setUserIsLogged');
    try {
      return super.setUserIsLogged(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusEmail(bool value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setFocusEmail');
    try {
      return super.setFocusEmail(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusSenha(bool value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setFocusSenha');
    try {
      return super.setFocusSenha(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusEntrar(bool value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setFocusEntrar');
    try {
      return super.setFocusEntrar(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusCriarConta(bool value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setFocusCriarConta');
    try {
      return super.setFocusCriarConta(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusRecuperarSenha(bool value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setFocusRecuperarSenha');
    try {
      return super.setFocusRecuperarSenha(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userIsLogged: ${userIsLogged},
focusEmail: ${focusEmail},
focusSenha: ${focusSenha},
focusEntrar: ${focusEntrar},
focusCriarConta: ${focusCriarConta},
focusRecuperarSenha: ${focusRecuperarSenha}
    ''';
  }
}
