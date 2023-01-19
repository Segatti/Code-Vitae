// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/app_store.dart';
part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase with Store {
  final AppStore appStore;

  _SettingsStoreBase(this.appStore);

  @action
  Future<void> changeTheme() async {
    bool value = appStore.themeIsDark;
    appStore.setThemeIsDark(!value);
  }
}
