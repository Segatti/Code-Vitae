import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/presenter/widgets/card_character.dart';

import '../../../../core/presenter/widgets/view/build_state_widget.dart';
import '../stores/residents_store.dart';

class ResidentsPage extends StatefulWidget {
  final String locationName;
  final List<int> ids;
  const ResidentsPage({
    super.key,
    required this.locationName,
    required this.ids,
  });

  @override
  State<ResidentsPage> createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  late ResidentsStore store;
  late CupertinoThemeData theme;

  @override
  void initState() {
    store = Modular.get<ResidentsStore>();
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
      title: widget.locationName,
      padding: EdgeInsets.zero,
      child: Observer(
        builder: (context) {
          return BuildStateWidget(
            pageState: store.pageState,
            widgetSuccessState: ListView.builder(
              itemCount: store.residents.length,
              itemBuilder: (context, index) {
                Character character = store.residents[index];
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
