// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  @observable
  bool themeIsDark = true;
  @action
  setThemeIsDark(bool value) => themeIsDark = value;
}
