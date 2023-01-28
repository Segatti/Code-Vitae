// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../../../core/utils/strings.dart';
import '../../../characters/domain/usecases/get_multiple_characters.dart';

part 'pdf_preview_store.g.dart';

class PdfPreviewStore = _PdfPreviewStoreBase with _$PdfPreviewStore;

abstract class _PdfPreviewStoreBase with Store {
  final IUCGetMultipleCharacters getMultipleCharacters;

  _PdfPreviewStoreBase({
    required this.getMultipleCharacters,
  });

  @observable
  List<Character> charactersList = [];
  @action
  setCharactersList(List<Character> value) => charactersList = value;

  @observable
  PageState pageState = StartState();
  @action
  setPageState(PageState value) => pageState = value;

  @observable
  Uint8List pdf = Uint8List(0);
  @action
  setPdf(Uint8List value) => pdf = value;

  @action
  Future<void> startStore(List<String> charactersIdList) async {
    setPageState(LoadingState());
    final result = await getMultipleCharacters(
        charactersIdList.map((e) => int.parse(e)).toList());

    await result.fold(
      (l) => setPageState(ErrorState()),
      (r) {
        setCharactersList(r);
      },
    );

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

        widgetCharacterList.add(pw.Partition(
            child: pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#000'),
            border: pw.Border.all(
              color: const PdfColor(0, 0, 0, 0),
            ),
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.LayoutBuilder(
            builder: (_, constrains) {
              return pw.Row(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(PaddingPattern.small),
                    width: (constrains?.maxWidth ?? 0) * 0.3,
                    height: (constrains?.maxWidth ?? 0) * 0.3,
                    child: pw.Image(netImage),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: (constrains?.maxWidth ?? 0) * 0.3,
                      padding: const pw.EdgeInsets.all(
                        PaddingPattern.small,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#FFF'),
                        borderRadius: const pw.BorderRadius.only(
                          bottomRight: pw.Radius.circular(12),
                          topRight: pw.Radius.circular(12),
                        ),
                      ),
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(validText("${character.name}"),
                              maxLines: 2,
                              style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                            validText(
                                "Origin: ${character.origin?.name ?? ''}"),
                            maxLines: 2,
                          ),
                          pw.Text(
                            validText("Species: ${character.species ?? ''}"),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )));
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
                      for (var widget in widgetCharacterList) widget,
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
