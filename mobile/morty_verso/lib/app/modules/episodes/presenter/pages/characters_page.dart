import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/presenter/widgets/card_character.dart';

import '../../../../core/presenter/widgets/view/build_state_widget.dart';
import '../stores/characters_store.dart';

class CharactersPage extends StatefulWidget {
  final String episodeName;
  final List<int> ids;
  const CharactersPage({
    super.key,
    required this.episodeName,
    required this.ids,
  });

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late CharactersStore store;
  late CupertinoThemeData theme;

  @override
  void initState() {
    store = Modular.get<CharactersStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore(widget.ids);
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return BasePageWidget(
      title: widget.episodeName,
      padding: EdgeInsets.zero,
      child: Observer(
        builder: (context) {
          return BuildStateWidget(
            pageState: store.pageState,
            widgetSuccessState: ListView.builder(
              itemCount: store.characters.length,
              itemBuilder: (context, index) {
                Character character = store.characters[index];
                return CardCharacter(
                  character: character,
                  isFavorite: false,
                  location: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
