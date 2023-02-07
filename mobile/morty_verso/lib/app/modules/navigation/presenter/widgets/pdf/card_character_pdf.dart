import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

import '../../../../../core/domain/patterns/padding_pattern.dart';
import '../../../../../core/utils/strings.dart';
import '../../../../characters/domain/entities/character.dart';

class CardCharacterPdf {
  final Character _character;
  final pdf.ImageProvider image;

  const CardCharacterPdf(this._character, this.image);

  pdf.Widget create() {
    return pdf.Partition(
        child: pdf.Container(
      decoration: pdf.BoxDecoration(
        color: PdfColor.fromHex('#000'),
        border: pdf.Border.all(
          color: const PdfColor(0, 0, 0, 0),
        ),
        borderRadius: pdf.BorderRadius.circular(12),
      ),
      child: pdf.LayoutBuilder(
        builder: (_, constrains) {
          return pdf.Row(
            children: [
              pdf.Container(
                padding: const pdf.EdgeInsets.all(PaddingPattern.small),
                width: (constrains?.maxWidth ?? 0) * 0.3,
                height: (constrains?.maxWidth ?? 0) * 0.3,
                child: pdf.Image(image),
              ),
              pdf.Expanded(
                child: pdf.Container(
                  height: (constrains?.maxWidth ?? 0) * 0.3,
                  padding: const pdf.EdgeInsets.all(
                    PaddingPattern.small,
                  ),
                  decoration: pdf.BoxDecoration(
                    color: PdfColor.fromHex('#FFF'),
                    borderRadius: const pdf.BorderRadius.only(
                      bottomRight: pdf.Radius.circular(12),
                      topRight: pdf.Radius.circular(12),
                    ),
                  ),
                  child: pdf.Column(
                    mainAxisSize: pdf.MainAxisSize.max,
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceAround,
                    crossAxisAlignment: pdf.CrossAxisAlignment.start,
                    children: [
                      pdf.Text(validText("${_character.name}"),
                          maxLines: 2,
                          style: pdf.TextStyle(
                              fontSize: 18, fontWeight: pdf.FontWeight.bold)),
                      pdf.Text(
                        validText("Origin: ${_character.origin?.name ?? ''}"),
                        maxLines: 2,
                      ),
                      pdf.Text(
                        validText("Species: ${_character.species ?? ''}"),
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
    ));
  }
}
