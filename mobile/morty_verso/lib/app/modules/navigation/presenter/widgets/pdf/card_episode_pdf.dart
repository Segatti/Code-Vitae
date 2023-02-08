import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

import '../../../../../core/domain/patterns/padding_pattern.dart';
import '../../../../../core/utils/strings.dart';
import '../../../../episodes/domain/entities/episode.dart';

class CardEpisodePdf {
  final Episode _episode;
  final pdf.ImageProvider image;

  const CardEpisodePdf(this._episode, this.image);

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
                width: (constrains?.maxWidth ?? 0) * 0.2,
                height: (constrains?.maxWidth ?? 0) * 0.2,
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
                      pdf.Text(validText("${_episode.episode} - ${_episode.name}"),
                          maxLines: 2,
                          style: pdf.TextStyle(
                              fontSize: 18, fontWeight: pdf.FontWeight.bold)),
                      pdf.Text(
                        validText("Air date: ${_episode.airDate ?? ''}"),
                        maxLines: 2,
                      ),
                      pdf.Text(
                        validText(
                            "Characters: ${_episode.characters?.length ?? '0'}"),
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
