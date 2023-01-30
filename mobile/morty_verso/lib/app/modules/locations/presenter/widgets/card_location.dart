import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/margin_pattern.dart';
import 'package:morty_verso/app/core/utils/strings.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../domain/entities/location.dart';

class CardLocation extends StatefulWidget {
  final Location location;
  final Function? onTap;
  final bool isFavorite;
  const CardLocation(
      {super.key,
      required this.location,
      this.onTap,
      required this.isFavorite});

  @override
  State<CardLocation> createState() => _CardLocationState();
}

class _CardLocationState extends State<CardLocation> {
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
                      './residents',
                      arguments: {
                        ""
                      }
                    );
                  },
                  child: const Text('Show residents'),
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
                  CupertinoIcons.placemark,
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
                          "${widget.location.name}${widget.isFavorite ? ' ☆' : ''}"),
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
                      validText("Type: ${widget.location.type ?? ''}"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: PaddingPattern.small),
                    AutoSizeText(
                      validText(
                          "Characters: ${widget.location.residents?.length ?? '0'}"),
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
