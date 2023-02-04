import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/build_state_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/paginacao_widget.dart';

import '../../../../core/domain/entities/page_states.dart';
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

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    textStyleTheme = theme.textTheme.textStyle;

    return BasePageWidget(
      title: 'Characters',
      padding: EdgeInsets.zero,
      trailing: Observer(builder: (context) {
        return GestureDetector(
          onTap: (store.favoriteCharactersIdList.isNotEmpty)
              ? () {
                  Modular.to.pushNamed('/favorites/characters');
                }
              : null,
          child: Text(
            'Favorites',
            style: TextStyle(
              color: (store.favoriteCharactersIdList.isNotEmpty)
                  ? CupertinoTheme.of(context).primaryColor
                  : CupertinoColors.inactiveGray,
              fontSize: 17,
              fontFamily: 'SF Pro',
            ),
          ),
        );
      }),
      child: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (context) => Column(
                children: [
                  Expanded(
                    child: BuildStateWidget(
                      pageState: store.pageState,
                      widgetSuccessState: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (_, index) {
                          Character character =
                              store.characters.results?[index] ??
                                  const Character();
                          bool isFavorite = store.favoriteCharactersIdList
                              .contains(character.id.toString());
                          return CardCharacter(
                            character: character,
                            onTap: () async {
                              String characterId = store
                                  .characters.results![index].id
                                  .toString();
                              List<String> characterList = store
                                  .favoriteCharactersIdList
                                  .map((e) => e)
                                  .toList();
                              (isFavorite)
                                  ? characterList.remove(characterId)
                                  : characterList.add(characterId);
                              await store
                                  .setFavoriteCharactersIdList(characterList);
                              await store.saveFavoriteCharactersLocalStorage();
                            },
                            isFavorite: isFavorite,
                          );
                        },
                        itemCount: store.characters.results?.length ?? 0,
                      ),
                    ),
                  ),
                  PaginacaoWidget(
                    scrollController: _scrollController,
                    numberPage: store.characters.info?.pages != null
                        ? "${store.currentPage}/${store.characters.info?.pages}"
                        : "???",
                    onTapPrevButton: (store.prevButton)
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
                    onTapNextButton: (store.nextButton)
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
