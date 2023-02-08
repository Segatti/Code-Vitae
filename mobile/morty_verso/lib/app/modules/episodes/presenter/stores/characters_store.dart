// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_multiple_characters.dart';

import '../../../../core/domain/entities/page_states.dart';
part 'characters_store.g.dart';

class CharactersStore = _CharactersStoreBase with _$CharactersStore;

abstract class _CharactersStoreBase with Store {
  final IUCGetMultipleCharacters getMultipleCharacters;

  _CharactersStoreBase(this.getMultipleCharacters);

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  List<Character> characters = [];
  @action
  setCharacters(List<Character> value) => characters = value;

  @action
  Future<void> startStore(List<int> ids) async {
    setPageState(LoadingState());
    await getCharacters(ids);
    if (pageState is LoadingState) setPageState(SuccessState());
  }

  @action
  Future<void> getCharacters(List<int> ids) async {
    final result = await getMultipleCharacters(ids);
    await result.fold(
      (l) async => setPageState(ErrorState()),
      (r) async {
        setCharacters(r);
      },
    );
  }
}
