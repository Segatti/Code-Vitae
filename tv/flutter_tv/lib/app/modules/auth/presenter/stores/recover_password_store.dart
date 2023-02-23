// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'recover_password_store.g.dart';

class RecoverPasswordStore = _RecoverPasswordStoreBase with _$RecoverPasswordStore;

abstract class _RecoverPasswordStoreBase with Store {
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
  bool focusEnviar = false;
  @action
  setFocusEnviar(bool value) => focusEnviar = value;

  @observable
  bool focusVoltar = false;
  @action
  setFocusVoltar(bool value) => focusVoltar = value;

  @action
  Future<void> startStore() async {}
}