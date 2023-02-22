// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  bool userIsLogged = false;
  @action
  setUserIsLogged(bool value) => userIsLogged = value;

  @observable
  bool focusEmail = false;
  @action
  setFocusEmail(bool value) => focusEmail = value;

  @observable
  bool focusSenha = false;
  @action
  setFocusSenha(bool value) => focusSenha = value;

  @observable
  bool focusEntrar = false;
  @action
  setFocusEntrar(bool value) => focusEntrar = value;

  @observable
  bool focusCriarConta = false;
  @action
  setFocusCriarConta(bool value) => focusCriarConta = value;

  @observable
  bool focusRecuperarSenha = false;
  @action
  setFocusRecuperarSenha(bool value) => focusRecuperarSenha = value;

  @action
  Future<void> startStore() async {}

  @action
  Future<void> login() async {}
}
