// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../domain/entities/characters.dart';
import '../../domain/usecases/get_all_characters.dart';
part 'all_characters_store.g.dart';

class AllCharactersStore = _AllCharactersStoreBase with _$AllCharactersStore;

abstract class _AllCharactersStoreBase with Store {
  final UCGetAllCharacters getAllCharacters;
  _AllCharactersStoreBase(this.getAllCharacters);

  @observable
  bool carregando = false;
  @action
  setCarregando(bool value) => carregando = value;

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @action
  Future<void> startStore() async {
    setCarregando(true);
    await getCharacters();
    setCarregando(false);
  }

  @observable
  Characters characters = const Characters();
  @action
  setCharacters(Characters value) => characters = value;

  @observable
  int currentPage = 1;
  @action
  setCurrentPage(int value) => currentPage = value;

  @action
  Future<void> getCharacters() async {
    setPageState(LoadingState());
    final response = await getAllCharacters(currentPage);
    await response.fold(
      (l) async {
        setPageState(ErrorState());
      },
      (r) async {
        setCharacters(r);
        setPageState(SuccessState());
      },
    );
  }
}
