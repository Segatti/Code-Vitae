// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
part 'character_store.g.dart';

class CharacterStore = _CharacterStoreBase with _$CharacterStore;

abstract class _CharacterStoreBase with Store {
  _CharacterStoreBase();

  @observable
  bool carregando = false;
  @action
  setCarregando(bool value) => carregando = value;

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;
}
