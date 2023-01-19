// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/core/core_module.dart';

import 'core/domain/usecases/get_value_local_storage.dart';
import 'core/domain/usecases/set_value_local_storage.dart';
part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final IUCGetValueLocalStorage getValueLocalStorage;
  final IUCSetValueLocalStorage setValueLocalStorage;

  _AppStoreBase(this.getValueLocalStorage, this.setValueLocalStorage);

  @observable
  bool themeIsDark = false;

  @action
  setThemeIsDark(bool value) async {
    themeIsDark = value;
    setValueLocalStorage('theme', value.toString());
  }

  @action
  Future<void> startStore() async {
    LocalStorage localStorage = Modular.get<LocalStorage>();
    await localStorage.ready;
    var result = await getValueLocalStorage('theme');
    result.fold((l) => setThemeIsDark(false), (r) {
      if (r == null) {
        setThemeIsDark(false);
      } else {
        bool parseValue = r.toLowerCase() == 'true';
        setThemeIsDark(parseValue);
      }
    });
  }
}
