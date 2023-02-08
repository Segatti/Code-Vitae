// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_one_character.dart';

import '../../../../core/domain/entities/page_states.dart';
part 'character_store.g.dart';

class CharacterStore = _CharacterStoreBase with _$CharacterStore;

abstract class _CharacterStoreBase with Store {
  final IUCGetOneCharacter getOneCharacter;

  _CharacterStoreBase(this.getOneCharacter);

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  Character character = const Character();
  @action
  setCharacter(Character value) => character = value;

  @action
  Future<void> startStore(int id) async {
    setPageState(LoadingState());
    await getCharacter(id);
    if (pageState is LoadingState) setPageState(SuccessState());
  }

  @action
  Future<void> getCharacter(int id) async {
    final result = await getOneCharacter(id);
    await result.fold(
      (l) async => setPageState(ErrorState()),
      (r) async {
        setCharacter(r);
      },
    );
  }
}
