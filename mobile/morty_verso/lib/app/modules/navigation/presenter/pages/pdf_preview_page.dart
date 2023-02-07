import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/build_state_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../stores/pdf_preview_store.dart';
import '../widgets/pdf/card_character_pdf.dart';
import '../widgets/pdf/card_episode_pdf.dart';
import '../widgets/pdf/card_location_pdf.dart';

class PdfPreviewPage extends StatefulWidget {
  final List<String> charactersIdList;
  final List<String> locationsIdList;
  final List<String> episodesIdList;
  const PdfPreviewPage({
    super.key,
    required this.charactersIdList,
    required this.locationsIdList,
    required this.episodesIdList,
  });

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  late PdfPreviewStore store;

  Future<Uint8List> generatePdf() async {
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

    for (var character in store.charactersList) {
      final netImage = await networkImage(character.image!);
      CardCharacterPdf cardCharacterPdf = CardCharacterPdf(character, netImage);

      widgetCharacterList.add(cardCharacterPdf.create());
    }

    List<pw.Widget> widgetLocationList = [];

    for (var location in store.locationsList) {
      final netImage = pw.MemoryImage(
        (await rootBundle.load('assets/icons/place.png')).buffer.asUint8List(),
      );

      CardLocationPdf cardLocationPdf = CardLocationPdf(location, netImage);

      widgetLocationList.add(cardLocationPdf.create());
    }

    List<pw.Widget> widgetEpisodeList = [];

    for (var episode in store.episodesList) {
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

    return await doc.save();
  }

  @override
  void initState() {
    store = Modular.get<PdfPreviewStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore(
      widget.charactersIdList,
      widget.locationsIdList,
      widget.episodesIdList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: 'PDF Preview',
      padding: EdgeInsets.zero,
      child: Observer(
        builder: (context) {
          return BuildStateWidget(
            pageState: store.pageState,
            widgetSuccessState: PdfPreview(
              build: (_) async => await generatePdf(),
              canDebug: false,
              canChangeOrientation: false,
            ),
          );
        },
      ),
    );
  }
}
