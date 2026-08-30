// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  bool userIsLogged = false;
  @action
  bool setUserIsLogged(bool value) => userIsLogged = value;

  @observable
  bool focusEmail = false;
  @action
  bool setFocusEmail(bool value) => focusEmail = value;

  @observable
  String email = "";
  @action
  String setEmail(String value) => email = value;
  

  @observable
  bool clickEmail = false;
  @action
  bool setClickEmail(bool value) => clickEmail = value;
  

  @observable
  bool focusSenha = false;
  @action
  bool setFocusSenha(bool value) => focusSenha = value;

  @observable
  String senha = "";
  @action
  String setSenha(String value) => senha = value;
  

  @observable
  bool clickSenha = false;
  @action
  bool setClickSenha(bool value) => clickSenha = value;
  

  @observable
  bool focusEntrar = false;
  @action
  bool setFocusEntrar(bool value) => focusEntrar = value;

  @observable
  bool focusCriarConta = false;
  @action
  bool setFocusCriarConta(bool value) => focusCriarConta = value;

  @observable
  bool focusRecuperarSenha = false;
  @action
  bool setFocusRecuperarSenha(bool value) => focusRecuperarSenha = value;

  @action
  Future<void> startStore() async {}

  @action
  Future<void> login() async {}
}
