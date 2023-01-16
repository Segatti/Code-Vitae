// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
part 'all_characters_store.g.dart';

class AllCharactersStore = _AllCharactersStoreBase with _$AllCharactersStore;

abstract class _AllCharactersStoreBase with Store {
  _AllCharactersStoreBase();

  @observable
  bool carregando = false;
  @action
  setCarregando(bool value) => carregando = value;

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;
  
  
}
