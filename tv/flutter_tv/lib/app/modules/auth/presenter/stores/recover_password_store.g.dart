// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecoverPasswordStore on _RecoverPasswordStoreBase, Store {
  late final _$focusEmailAtom =
      Atom(name: '_RecoverPasswordStoreBase.focusEmail', context: context);

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

  late final _$emailAtom =
      Atom(name: '_RecoverPasswordStoreBase.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$clickEmailAtom =
      Atom(name: '_RecoverPasswordStoreBase.clickEmail', context: context);

  @override
  bool get clickEmail {
    _$clickEmailAtom.reportRead();
    return super.clickEmail;
  }

  @override
  set clickEmail(bool value) {
    _$clickEmailAtom.reportWrite(value, super.clickEmail, () {
      super.clickEmail = value;
    });
  }

  late final _$focusEnviarAtom =
      Atom(name: '_RecoverPasswordStoreBase.focusEnviar', context: context);

  @override
  bool get focusEnviar {
    _$focusEnviarAtom.reportRead();
    return super.focusEnviar;
  }

  @override
  set focusEnviar(bool value) {
    _$focusEnviarAtom.reportWrite(value, super.focusEnviar, () {
      super.focusEnviar = value;
    });
  }

  late final _$focusVoltarAtom =
      Atom(name: '_RecoverPasswordStoreBase.focusVoltar', context: context);

  @override
  bool get focusVoltar {
    _$focusVoltarAtom.reportRead();
    return super.focusVoltar;
  }

  @override
  set focusVoltar(bool value) {
    _$focusVoltarAtom.reportWrite(value, super.focusVoltar, () {
      super.focusVoltar = value;
    });
  }

  late final _$startStoreAsyncAction =
      AsyncAction('_RecoverPasswordStoreBase.startStore', context: context);

  @override
  Future<void> startStore() {
    return _$startStoreAsyncAction.run(() => super.startStore());
  }

  late final _$_RecoverPasswordStoreBaseActionController =
      ActionController(name: '_RecoverPasswordStoreBase', context: context);

  @override
  dynamic setFocusEmail(bool value) {
    final _$actionInfo = _$_RecoverPasswordStoreBaseActionController
        .startAction(name: '_RecoverPasswordStoreBase.setFocusEmail');
    try {
      return super.setFocusEmail(value);
    } finally {
      _$_RecoverPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEmail(String value) {
    final _$actionInfo = _$_RecoverPasswordStoreBaseActionController
        .startAction(name: '_RecoverPasswordStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_RecoverPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setClickEmail(bool value) {
    final _$actionInfo = _$_RecoverPasswordStoreBaseActionController
        .startAction(name: '_RecoverPasswordStoreBase.setClickEmail');
    try {
      return super.setClickEmail(value);
    } finally {
      _$_RecoverPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusEnviar(bool value) {
    final _$actionInfo = _$_RecoverPasswordStoreBaseActionController
        .startAction(name: '_RecoverPasswordStoreBase.setFocusEnviar');
    try {
      return super.setFocusEnviar(value);
    } finally {
      _$_RecoverPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFocusVoltar(bool value) {
    final _$actionInfo = _$_RecoverPasswordStoreBaseActionController
        .startAction(name: '_RecoverPasswordStoreBase.setFocusVoltar');
    try {
      return super.setFocusVoltar(value);
    } finally {
      _$_RecoverPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
focusEmail: ${focusEmail},
email: ${email},
clickEmail: ${clickEmail},
focusEnviar: ${focusEnviar},
focusVoltar: ${focusVoltar}
    ''';
  }
}
