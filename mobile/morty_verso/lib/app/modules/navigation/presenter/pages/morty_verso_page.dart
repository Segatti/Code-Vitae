import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

import '../../../../core/presenter/widgets/general/text_widget.dart';

class MortyVersoPage extends StatelessWidget {
  const MortyVersoPage({super.key});

  @override
  Widget build(BuildContext context) {
    CupertinoThemeData theme = CupertinoTheme.of(context);

    return BasePageWidget(
      title: 'Morty Verso',
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: theme.textTheme.textStyle.color!.withOpacity(.25),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoListTile(
                    title: const TextWidget(text: 'Characters', fontSize: 17),
                    backgroundColor: theme.barBackgroundColor,
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      Modular.to.pushNamed('/characters/');
                    },
                  ),
                  CupertinoListTile(
                    title: const TextWidget(text: 'Locations', fontSize: 17),
                    backgroundColor: theme.barBackgroundColor,
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      Modular.to.pushNamed('/locations/');
                    },
                  ),
                  CupertinoListTile(
                    title: const TextWidget(text: 'Episodes', fontSize: 17),
                    backgroundColor: theme.barBackgroundColor,
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      Modular.to.pushNamed('/episodes/');
                    },
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
