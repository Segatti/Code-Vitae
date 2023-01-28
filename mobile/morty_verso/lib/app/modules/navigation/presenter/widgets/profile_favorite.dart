import 'package:flutter/cupertino.dart';
import 'package:morty_verso/app/core/presenter/widgets/general/text_widget.dart';

import '../../../../core/domain/patterns/font_pattern.dart';
import '../../../../core/domain/patterns/padding_pattern.dart';

class ProfileFavorite extends StatefulWidget {
  final List<String> characters;
  final List<String> planets;
  final List<String> episodes;
  final Function? generatePDF;
  const ProfileFavorite({
    super.key,
    required this.characters,
    required this.planets,
    required this.episodes,
    this.generatePDF,
  });

  @override
  State<ProfileFavorite> createState() => _ProfileFavoriteState();
}

class _ProfileFavoriteState extends State<ProfileFavorite> {
  late CupertinoThemeData theme;
  late TextStyle textStyleTheme;

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    textStyleTheme = theme.textTheme.textStyle;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: PaddingPattern.medium),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color.fromARGB(68, 0, 0, 0),
                      )
                    ],
                    color: theme.barBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(13),
                      topRight: Radius.circular(13),
                    )),
                child: const Center(
                  child: TextWidget(text: 'FAVORITES', fontSize: 12),
                ),
              ),
            )
          ],
        ),
        LayoutBuilder(
          builder: (_, constrains) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: CupertinoColors.systemYellow.withAlpha(200),
                  width: constrains.maxWidth * 0.3,
                  child: Column(
                    children: [
                      Container(
                        width: constrains.maxWidth * 0.3,
                        height: constrains.maxWidth * 0.3,
                        color: CupertinoColors.systemYellow,
                        child: Icon(
                          CupertinoIcons.person,
                          size: 50,
                          color: CupertinoColors.black.withOpacity(.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(PaddingPattern.small),
                        child: TextWidget(
                          text: widget.characters.length.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: CupertinoColors.systemRed.withAlpha(200),
                  width: constrains.maxWidth * 0.3,
                  child: Column(
                    children: [
                      Container(
                        width: constrains.maxWidth * 0.3,
                        height: constrains.maxWidth * 0.3,
                        color: CupertinoColors.systemRed,
                        child: Icon(
                          CupertinoIcons.placemark,
                          size: 50,
                          color: CupertinoColors.black.withOpacity(.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(PaddingPattern.small),
                        child: TextWidget(
                          text: widget.planets.length.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: CupertinoColors.systemGreen.withAlpha(200),
                  width: constrains.maxWidth * 0.3,
                  child: Column(
                    children: [
                      Container(
                        width: constrains.maxWidth * 0.3,
                        height: constrains.maxWidth * 0.3,
                        color: CupertinoColors.systemGreen,
                        child: Icon(
                          CupertinoIcons.play_circle,
                          size: 50,
                          color: CupertinoColors.black.withOpacity(.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(PaddingPattern.small),
                        child: TextWidget(
                          text: widget.episodes.length.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: PaddingPattern.big),
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                onPressed: (widget.characters.isNotEmpty)
                    ? () {
                        if (widget.generatePDF != null) {
                          widget.generatePDF!();
                        }
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Share favorites',
                      style: TextStyle(
                        fontSize: FontPattern.small,
                      ),
                    ),
                    const Icon(CupertinoIcons.share),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
