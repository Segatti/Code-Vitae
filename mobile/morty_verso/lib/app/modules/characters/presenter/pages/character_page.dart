import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/app_bar_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

import '../stores/character_store.dart';
import '../widgets/text_info.dart';

class CharacterPage extends StatefulWidget {
  final int id;
  const CharacterPage({super.key, required this.id});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late CharacterStore store;

  @override
  void initState() {
    store = Modular.get<CharacterStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore(widget.id);
  }

  Widget buildState(PageState pageState) {
    if (pageState is StartState) {
      return const Center(
        child: Text('Starting dimensional portal...'),
      );
    } else if (pageState is LoadingState) {
      return const Center(
        child: RepaintBoundary(child: CircularProgressIndicator()),
      );
    } else if (pageState is ErrorState) {
      return const Center(
        child: Text('Error: Problems with the dimensional portal'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constrains) {
                      return Center(
                        child: SizedBox(
                          height: constrains.maxWidth * 0.5,
                          width: constrains.maxWidth * 0.5,
                          child: CachedNetworkImage(
                            imageUrl: store.character.image ?? '',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: PaddingPattern.big),
            TextInfo(keyValue: 'Name', value: store.character.name ?? ''),
            const SizedBox(height: PaddingPattern.small),
            TextInfo(keyValue: 'Species', value: store.character.species ?? ''),
            const SizedBox(height: PaddingPattern.small),
            TextInfo(keyValue: 'Gender', value: store.character.gender ?? ''),
            const SizedBox(height: PaddingPattern.small),
            TextInfo(keyValue: 'Status', value: store.character.status ?? ''),
            const SizedBox(height: PaddingPattern.small),
            TextInfo(
                keyValue: 'Origin', value: store.character.origin?.name ?? ''),
            const SizedBox(height: PaddingPattern.small),
            TextInfo(
                keyValue: 'Location',
                value: store.character.location?.name ?? ''),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBarWidget(title: store.character.name ?? ''),
        body: BasePageWidget(
            title: 'Character',
            child: Observer(builder: (context) {
              return buildState(store.pageState);
            })),
      );
    });
  }
}
