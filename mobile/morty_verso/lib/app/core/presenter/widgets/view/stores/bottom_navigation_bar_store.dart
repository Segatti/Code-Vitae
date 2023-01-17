// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'bottom_navigation_bar_store.g.dart';

class BottomNavigationBarStore = _BottomNavigationBarStoreBase
    with _$BottomNavigationBarStore;

abstract class _BottomNavigationBarStoreBase with Store {
  _BottomNavigationBarStoreBase();

  @observable
  int currentIndex = 0;
  @action
  setCurrentIndex(int value) => currentIndex = value;

  @action
  Future<void> startStore(int initialValue) async {
    setCurrentIndex(initialValue);
  }
}
