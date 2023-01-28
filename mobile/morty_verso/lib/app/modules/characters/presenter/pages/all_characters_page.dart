import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../../../core/domain/patterns/margin_pattern.dart';
import '../../domain/entities/character.dart';
import '../stores/all_characters_store.dart';
import '../widgets/card_character.dart';

class AllCharactersPage extends StatefulWidget {
  const AllCharactersPage({super.key});

  @override
  State<AllCharactersPage> createState() => _AllCharactersPageState();
}

class _AllCharactersPageState extends State<AllCharactersPage> {
  late AllCharactersStore store;
  final ScrollController _scrollController = ScrollController();
  late CupertinoThemeData theme;
  late TextStyle textStyleTheme;

  @override
  void initState() {
    store = Modular.get<AllCharactersStore>();
    _init();
    super.initState();
  }

  Future _init() async {
    await store.startStore();
  }

  Widget buildState(PageState pageState) {
    if (pageState is StartState) {
      return const Center(
        child: Text('Starting dimensional portal...'),
      );
    } else if (pageState is LoadingState) {
      return const Center(
        child: RepaintBoundary(child: CupertinoActivityIndicator()),
      );
    } else if (pageState is ErrorState) {
      return const Center(
        child: Text('Error: Problems with the dimensional portal'),
      );
    } else {
      return ListView.separated(
        controller: _scrollController,
        itemBuilder: (_, index) {
          Character character =
              store.characters.results?[index] ?? const Character();
          bool isFavorite =
              store.favoriteCharactersIdList.contains(character.id.toString());
          return CardCharacter(
            character: character,
            onTap: () async {
              String characterId =
                  store.characters.results![index].id.toString();
              List<String> characterList =
                  store.favoriteCharactersIdList.map((e) => e).toList();
              (isFavorite)
                  ? characterList.remove(characterId)
                  : characterList.add(characterId);
              await store.setFavoriteCharactersIdList(characterList);
              await store.saveFavoriteCharactersLocalStorage();
            },
            isFavorite: isFavorite,
          );
        },
        separatorBuilder: (_, __) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: MarginPattern.small,
            ),
            child: Container(
              color: CupertinoColors.systemYellow,
              height: 2,
            ),
          );
        },
        itemCount: store.characters.results?.length ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    textStyleTheme = theme.textTheme.textStyle;

    return BasePageWidget(
      title: 'Characters',
      trailing: GestureDetector(
        child: Text(
          'Favorites',
          style: TextStyle(
            color: CupertinoTheme.of(context).primaryColor,
            fontSize: 17,
            fontFamily: 'SF Pro',
          ),
        ),
        onTap: () {
          Modular.to.pushNamed('./favorites');
        },
      ),
      child: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (context) => Column(
                children: [
                  Expanded(child: buildState(store.pageState)),
                  const SizedBox(height: MarginPattern.medium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        color: CupertinoColors.activeBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingPattern.big,
                        ),
                        onPressed: (store.prevButton)
                            ? () async {
                                _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn,
                                );
                                store.setCurrentPage(store.currentPage - 1);
                                store.setPageState(LoadingState());
                                await store.getCharacters();
                                if (store.pageState is LoadingState) {
                                  store.setPageState(SuccessState());
                                }
                              }
                            : null,
                        child: Row(
                          children: const [
                            Icon(CupertinoIcons.chevron_left),
                            Text('Prev'),
                          ],
                        ),
                      ),
                      (store.characters.info?.pages != null)
                          ? Text(
                              "${store.currentPage}/${store.characters.info?.pages}")
                          : const Text('???'),
                      CupertinoButton(
                        color: CupertinoColors.activeBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingPattern.big,
                        ),
                        onPressed: (store.nextButton)
                            ? () async {
                                _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn,
                                );
                                store.setCurrentPage(store.currentPage + 1);
                                store.setPageState(LoadingState());
                                await store.getCharacters();
                                if (store.pageState is LoadingState) {
                                  store.setPageState(SuccessState());
                                }
                              }
                            : null,
                        child: Row(
                          children: const [
                            Text('Next'),
                            Icon(CupertinoIcons.chevron_right),
                          ],
                        ),
                      ),
                    ],
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
