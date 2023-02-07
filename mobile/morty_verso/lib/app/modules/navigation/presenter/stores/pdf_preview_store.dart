// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../../characters/domain/entities/character.dart';
import '../../../characters/domain/usecases/get_multiple_characters.dart';
import '../../../episodes/domain/entities/episode.dart';
import '../../../episodes/domain/usecases/get_multiple_episodes.dart';
import '../../../locations/domain/entities/location.dart';
import '../../../locations/domain/usecases/get_multiple_locations.dart';

part 'pdf_preview_store.g.dart';

class PdfPreviewStore = _PdfPreviewStoreBase with _$PdfPreviewStore;

abstract class _PdfPreviewStoreBase with Store {
  final IUCGetMultipleCharacters getMultipleCharacters;
  final IUCGetMultipleLocations getMultipleLocations;
  final IUCGetMultipleEpisodes getMultipleEpisodes;

  _PdfPreviewStoreBase(
    this.getMultipleLocations,
    this.getMultipleEpisodes,
    this.getMultipleCharacters,
  );

  @observable
  List<Character> charactersList = [];
  @action
  setCharactersList(List<Character> value) => charactersList = value;

  @observable
  List<Location> locationsList = [];
  @action
  setLocationsList(List<Location> value) => locationsList = value;

  @observable
  List<Episode> episodesList = [];
  @action
  setEpisodesList(List<Episode> value) => episodesList = value;

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @action
  Future<void> startStore(
    List<String> charactersIdList,
    List<String> locationsIdList,
    List<String> episodesIdList,
  ) async {
    setPageState(LoadingState());
    if (charactersIdList.isNotEmpty) {
      final resultCharacters = await getMultipleCharacters(
          charactersIdList.map((e) => int.parse(e)).toList());

      await resultCharacters.fold(
        (l) => setPageState(ErrorState()),
        (r) {
          setCharactersList(r);
        },
      );
    }

    if (locationsIdList.isNotEmpty) {
      final resultLocations = await getMultipleLocations(
          locationsIdList.map((e) => int.parse(e)).toList());

      await resultLocations.fold(
        (l) => setPageState(ErrorState()),
        (r) {
          setLocationsList(r);
        },
      );
    }

    if (episodesIdList.isNotEmpty) {
      final resultEpisodes = await getMultipleEpisodes(
          episodesIdList.map((e) => int.parse(e)).toList());

      await resultEpisodes.fold(
        (l) => setPageState(ErrorState()),
        (r) {
          setEpisodesList(r);
        },
      );
    }

    if (pageState is LoadingState) setPageState(SuccessState());
  }
}
