import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/utils/strings.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';
import '../../domain/entities/character.dart';

class CardCharacter extends StatelessWidget {
  final Character character;
  final Function? onTap;
  final bool isFavorite;
  const CardCharacter(
      {super.key,
      required this.character,
      this.onTap,
      required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5.0,
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => SafeArea(
              child: CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Modular.to.pop();
                      Modular.to
                          .pushNamed('/characters/character/${character.id}');
                    },
                    child: const Text('More details'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      if (onTap is Function) {
                        await onTap!();
                        Modular.to.pop();
                      }
                    },
                    child: isFavorite
                        ? const Text('Unmark favorite')
                        : const Text('Mark favorite'),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ),
          );
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            side: BorderSide(
              width: 2,
              color: Colors.grey,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (_, constrains) {
                  return Row(
                    children: [
                      SizedBox(
                        width: constrains.maxWidth * 0.4,
                        height: constrains.maxWidth * 0.4,
                        child: CachedNetworkImage(
                          imageUrl: character.image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: constrains.maxWidth * 0.4,
                          padding: const EdgeInsets.all(
                            PaddingPattern.small,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                validText(
                                    "${character.name}${isFavorite ? ' ☆' : ''}"),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: (isFavorite) ? Colors.orange : null,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AutoSizeText(
                                validText(
                                    "Origin: ${character.origin?.name ?? ''}"),
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                validText(
                                    "Species: ${character.species ?? ''}"),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
