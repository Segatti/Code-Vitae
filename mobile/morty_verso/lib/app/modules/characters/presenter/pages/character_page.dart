import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/build_state_widget.dart';

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
  late CupertinoThemeData theme;

  @override
  void initState() {
    store = Modular.get<CharacterStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);

    return Observer(builder: (context) {
      return BasePageWidget(
        title: store.character.name ?? '',
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingPattern.small,
          vertical: PaddingPattern.big,
        ),
        child: Observer(
          builder: (context) {
            return BuildStateWidget(
              pageState: store.pageState,
              widgetSuccessState: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (_, constrains) {
                              return Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: SizedBox(
                                    height: constrains.maxWidth * 0.5,
                                    width: constrains.maxWidth * 0.5,
                                    child: CachedNetworkImage(
                                      imageUrl: store.character.image ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                              CupertinoIcons.xmark_circle),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: PaddingPattern.big),
                    TextInfo(
                      keyValue: 'Name',
                      value: store.character.name ?? '',
                      top: true,
                    ),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    TextInfo(
                        keyValue: 'Species',
                        value: store.character.species ?? ''),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    TextInfo(
                        keyValue: 'Gender',
                        value: store.character.gender ?? ''),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    TextInfo(
                        keyValue: 'Status',
                        value: store.character.status ?? ''),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    TextInfo(
                        keyValue: 'Origin',
                        value: store.character.origin?.name ?? ''),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    TextInfo(
                      keyValue: 'Location',
                      value: store.character.location?.name ?? '',
                      bottom: true,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
