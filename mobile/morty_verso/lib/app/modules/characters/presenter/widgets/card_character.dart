import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/margin_pattern.dart';
import 'package:morty_verso/app/core/utils/strings.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../domain/entities/character.dart';

class CardCharacter extends StatefulWidget {
  final Character character;
  final Function? onTap;
  final bool isFavorite;
  final bool location;
  const CardCharacter({
    super.key,
    required this.character,
    this.onTap,
    required this.isFavorite,
    this.location = false,
  });

  @override
  State<CardCharacter> createState() => _CardCharacterState();
}

class _CardCharacterState extends State<CardCharacter> {
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
                CupertinoActionSheetAction(
                  onPressed: () {
                    Modular.to.pop();
                    Modular.to.pushNamed(
                        '/characters/character/${widget.character.id}');
                  },
                  child: const Text('More details'),
                ),
                if (!widget.location)
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
              child: SizedBox(
                width: 100,
                height: 100,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    (widget.isFavorite || widget.location)
                        ? Colors.transparent
                        : Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.character.image ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(CupertinoIcons.xmark_circle)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: PaddingPattern.medium),
            Container(
              height: 100,
              width: 1,
              color: theme.textTheme.textStyle.color?.withOpacity(.25),
            ),
            const SizedBox(width: PaddingPattern.medium),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      validText(
                          "${widget.character.name}${widget.isFavorite ? ' ☆' : ''}"),
                      maxLines: 2,
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
                      validText(
                          "Origin: ${widget.character.origin?.name ?? ''}"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: PaddingPattern.small),
                    AutoSizeText(
                      validText("Species: ${widget.character.species ?? ''}"),
                      maxLines: 2,
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
