// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobx/mobx.dart';

import 'core/domain/usecases/theme/get_theme.dart';
import 'core/domain/usecases/theme/set_theme.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final IUCGetTheme getTheme;
  final IUCSetTheme setTheme;

  _AppStoreBase(this.getTheme, this.setTheme);

  @computed
  bool get themeIsDark => themeData.brightness == Brightness.dark;

  @observable
  CupertinoThemeData themeData =
      const CupertinoThemeData(brightness: Brightness.light);
  @action
  setThemeData(CupertinoThemeData value) => themeData = value;

  @action
  Future<void> getThemeStorage() async {
    setThemeData(await getTheme());
  }

  @action
  Future<void> toggleThemeStorage() async {
    await setTheme(
      themeData.brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    );
    await getThemeStorage();
  }

  @action
  Future<void> startStore() async {
    LocalStorage localStorage = Modular.get<LocalStorage>();
    await localStorage.ready;
    await getThemeStorage();
  }
}
