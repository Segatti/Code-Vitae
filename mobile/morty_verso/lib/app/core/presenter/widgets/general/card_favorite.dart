import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../../domain/entities/favorite_item.dart';
import '../../../domain/patterns/margin_pattern.dart';
import '../../../utils/strings.dart';

class CardFavorite extends StatefulWidget {
  final FavoriteItem favoriteItem;
  const CardFavorite({
    super.key,
    required this.favoriteItem,
  });

  @override
  State<CardFavorite> createState() => _CardFavoriteState();
}

class _CardFavoriteState extends State<CardFavorite> {
  late CupertinoThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return Container(
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
              child: (widget.favoriteItem.image.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: widget.favoriteItem.image,
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
                      errorWidget: (context, url, error) => const Center(
                          child: Icon(CupertinoIcons.xmark_circle)),
                    )
                  : Center(child: widget.favoriteItem.icon),
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
                    validText("${widget.favoriteItem.title} ☆"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: CupertinoColors.activeOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: PaddingPattern.small),
                  AutoSizeText(
                    validText(widget.favoriteItem.info1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: PaddingPattern.small),
                  AutoSizeText(
                    validText(widget.favoriteItem.info2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
