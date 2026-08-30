// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
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
  bool focusConfirmarSenha = false;
  @action
  bool setFocusConfirmarSenha(bool value) => focusConfirmarSenha = value;

  @observable
  String confirmarSenha = "";
  @action
  String setConfirmarSenha(String value) => confirmarSenha = value;
  

  @observable
  bool clickConfirmarSenha = false;
  @action
  bool setClickConfirmarSenha(bool value) => clickConfirmarSenha = value;
  

  @observable
  bool focusEntrar = false;
  @action
  bool setFocusEntrar(bool value) => focusEntrar = value;

  @observable
  bool focusCriarConta = false;
  @action
  bool setFocusCriarConta(bool value) => focusCriarConta = value;
  
  @action
  Future<void> startStore() async {}
}