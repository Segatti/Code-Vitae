// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  _SplashStoreBase();

  @observable
  bool userIsLogged = false;
  @action
  setUserIsLogged(bool value) => userIsLogged = value;
  

  @action
  Future<void> startStore() async {
    // Verificar se está logado ou não com Firebase
  }
}
