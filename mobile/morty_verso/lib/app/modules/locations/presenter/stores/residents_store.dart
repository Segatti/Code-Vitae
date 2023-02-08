// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_multiple_characters.dart';

import '../../../../core/domain/entities/page_states.dart';
part 'residents_store.g.dart';

class ResidentsStore = _ResidentsStoreBase with _$ResidentsStore;

abstract class _ResidentsStoreBase with Store {
  final IUCGetMultipleCharacters getMultipleCharacters;

  _ResidentsStoreBase(this.getMultipleCharacters);

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  List<Character> residents = [];
  @action
  setResidents(List<Character> value) => residents = value;

  @action
  Future<void> startStore(List<int> ids) async {
    setPageState(LoadingState());
    await getResidents(ids);
    if (pageState is LoadingState) setPageState(SuccessState());
  }

  @action
  Future<void> getResidents(List<int> ids) async {
    final result = await getMultipleCharacters(ids);
    await result.fold(
      (l) async => setPageState(ErrorState()),
      (r) async {
        setResidents(r);
      },
    );
  }
}
