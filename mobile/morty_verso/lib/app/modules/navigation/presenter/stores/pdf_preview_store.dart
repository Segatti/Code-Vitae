// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../../characters/domain/entities/character.dart';
import '../../../characters/domain/usecases/get_multiple_characters.dart';
import '../../../episodes/domain/entities/episode.dart';
import '../../../episodes/domain/usecases/get_multiple_episodes.dart';
import '../../../locations/domain/entities/location.dart';
import '../../../locations/domain/usecases/get_multiple_locations.dart';
import '../widgets/pdf/card_character_pdf.dart';
import '../widgets/pdf/card_episode_pdf.dart';
import '../widgets/pdf/card_location_pdf.dart';

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

  @observable
  Uint8List pdf = Uint8List(0);
  @action
  setPdf(Uint8List value) => pdf = value;

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

    if (pageState is LoadingState) {
      const PdfColor green = PdfColor.fromInt(0xff9ce5d0);

      var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Roboto/Roboto-Regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Roboto/Roboto-Bold.ttf")),
        italic: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Roboto/Roboto-Italic.ttf")),
      );
      final doc = pw.Document(
          title: 'My Favorites', author: 'Vittor Feitosa', theme: myTheme);

      List<pw.Widget> widgetCharacterList = [];

      for (var character in charactersList) {
        final netImage = await networkImage(character.image!);
        CardCharacterPdf cardCharacterPdf =
            CardCharacterPdf(character, netImage);

        widgetCharacterList.add(cardCharacterPdf.create());
      }

      List<pw.Widget> widgetLocationList = [];

      for (var location in locationsList) {
        final netImage = pw.MemoryImage(
          (await rootBundle.load('assets/icons/place.png'))
              .buffer
              .asUint8List(),
        );

        CardLocationPdf cardLocationPdf = CardLocationPdf(location, netImage);

        widgetLocationList.add(cardLocationPdf.create());
      }

      List<pw.Widget> widgetEpisodeList = [];

      for (var episode in episodesList) {
        final netImage = pw.MemoryImage(
          (await rootBundle.load('assets/icons/play.png')).buffer.asUint8List(),
        );

        CardEpisodePdf cardEpisodePdf = CardEpisodePdf(episode, netImage);

        widgetEpisodeList.add(cardEpisodePdf.create());
      }

      doc.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Partitions(
              children: [
                pw.Partition(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Container(
                        padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            pw.Text('Morty Verso',
                                textScaleFactor: 2,
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(fontWeight: pw.FontWeight.bold)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 10)),
                            pw.Text('My Favorites',
                                textScaleFactor: 1.2,
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontWeight: pw.FontWeight.bold,
                                        color: green)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 20)),
                          ],
                        ),
                      ),
                      if (widgetCharacterList.isNotEmpty)
                        pw.Column(
                          children: [
                            pw.Center(
                              child: pw.Text('Characters'),
                            ),
                            pw.SizedBox(height: PaddingPattern.small),
                            for (var widget in widgetCharacterList) widget,
                          ],
                        ),
                      if (widgetLocationList.isNotEmpty)
                        pw.Column(children: [
                          pw.SizedBox(height: PaddingPattern.medium),
                          pw.Center(
                            child: pw.Text('Locations'),
                          ),
                          pw.SizedBox(height: PaddingPattern.small),
                          for (var widget in widgetLocationList) widget,
                        ]),
                      if (widgetEpisodeList.isNotEmpty)
                        pw.Column(children: [
                          pw.SizedBox(height: PaddingPattern.medium),
                          pw.Center(
                            child: pw.Text('Episodes'),
                          ),
                          pw.SizedBox(height: PaddingPattern.small),
                          for (var widget in widgetEpisodeList) widget,
                        ]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      setPdf(await doc.save());
      setPageState(SuccessState());
    }
  }
}
