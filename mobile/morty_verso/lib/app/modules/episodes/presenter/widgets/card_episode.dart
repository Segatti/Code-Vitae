import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/margin_pattern.dart';
import 'package:morty_verso/app/core/utils/strings.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../domain/entities/episode.dart';

class CardEpisode extends StatefulWidget {
  final Episode episode;
  final Function? onTap;
  final bool isFavorite;
  const CardEpisode({
    super.key,
    required this.episode,
    this.onTap,
    required this.isFavorite,
  });

  @override
  State<CardEpisode> createState() => _CardEpisodeState();
}

class _CardEpisodeState extends State<CardEpisode> {
  late CupertinoThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => SafeArea(
            child: CupertinoActionSheet(
              title: const Text('What do you want to do?'),
              actions: [
                if (widget.episode.characters?.isNotEmpty ?? false)
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Modular.to.pop();
                      Modular.to.pushNamed('./characters', arguments: {
                        "characters_ids": widget.episode.characters
                            ?.map((e) => int.parse(e.split('/').last))
                            .toList(),
                        "episode_name": widget.episode.name,
                      });
                    },
                    child: const Text('Show characters'),
                  ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    if (widget.onTap is Function) {
                      await widget.onTap!();
                      Modular.to.pop();
                    }
                  },
                  child: widget.isFavorite
                      ? const Text('Unmark favorite')
                      : const Text('Mark favorite'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Modular.to.pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: CupertinoColors.systemRed),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(MarginPattern.small),
        padding: const EdgeInsets.all(PaddingPattern.medium),
        decoration: BoxDecoration(
            color: theme.barBackgroundColor.withOpacity(1),
            border: Border.all(
              color: theme.textTheme.textStyle.color!.withOpacity(.25),
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: theme.textTheme.textStyle.color!.withOpacity(.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Center(
                child: Icon(
                  CupertinoIcons.play_circle,
                  size: 50,
                  color: widget.isFavorite
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: PaddingPattern.medium),
                margin: const EdgeInsets.only(left: MarginPattern.medium),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.textTheme.textStyle.color!.withOpacity(.25),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      validText(
                          "${widget.episode.episode} - ${widget.episode.name}${widget.isFavorite ? ' ☆' : ''}"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: (widget.isFavorite)
                            ? CupertinoColors.activeOrange
                            : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: PaddingPattern.small),
                    AutoSizeText(
                      validText("Air date: ${widget.episode.airDate ?? ''}"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: PaddingPattern.small),
                    AutoSizeText(
                      validText(
                          "Characters: ${widget.episode.characters?.length ?? '0'}"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
