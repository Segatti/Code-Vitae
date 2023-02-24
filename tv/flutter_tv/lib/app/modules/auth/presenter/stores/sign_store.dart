// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
  @observable
  bool focusEmail = false;
  @action
  setFocusEmail(bool value) => focusEmail = value;

  @observable
  String email = "";
  @action
  setEmail(String value) => email = value;
  

  @observable
  bool clickEmail = false;
  @action
  setClickEmail(bool value) => clickEmail = value;
  

  @observable
  bool focusSenha = false;
  @action
  setFocusSenha(bool value) => focusSenha = value;

  @observable
  String senha = "";
  @action
  setSenha(String value) => senha = value;
  

  @observable
  bool clickSenha = false;
  @action
  setClickSenha(bool value) => clickSenha = value;

  @observable
  bool focusConfirmarSenha = false;
  @action
  setFocusConfirmarSenha(bool value) => focusConfirmarSenha = value;

  @observable
  String confirmarSenha = "";
  @action
  setConfirmarSenha(String value) => confirmarSenha = value;
  

  @observable
  bool clickConfirmarSenha = false;
  @action
  setClickConfirmarSenha(bool value) => clickConfirmarSenha = value;
  

  @observable
  bool focusEntrar = false;
  @action
  setFocusEntrar(bool value) => focusEntrar = value;

  @observable
  bool focusCriarConta = false;
  @action
  setFocusCriarConta(bool value) => focusCriarConta = value;
  
  @action
  Future<void> startStore() async {}
}