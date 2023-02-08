import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../../../core/presenter/widgets/view/build_state_widget.dart';
import '../../../../core/presenter/widgets/view/paginacao_widget.dart';
import '../../domain/entities/episode.dart';
import '../stores/all_episodes_store.dart';
import '../widgets/card_episode.dart';

class AllEpisodesPage extends StatefulWidget {
  const AllEpisodesPage({super.key});

  @override
  State<AllEpisodesPage> createState() => _AllEpisodesPageState();
}

class _AllEpisodesPageState extends State<AllEpisodesPage> {
  late AllEpisodesStore store;
  final ScrollController _scrollController = ScrollController();
  late CupertinoThemeData theme;
  late TextStyle textStyleTheme;

  @override
  void initState() {
    store = Modular.get<AllEpisodesStore>();
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
      title: 'Episodes',
      padding: EdgeInsets.zero,
      trailing: Observer(builder: (context) {
        return GestureDetector(
          onTap: (store.favoriteEpisodesIdList.isNotEmpty)
              ? () {
                  Modular.to.pushNamed('/favorites/episodes');
                }
              : null,
          child: Text(
            'Favorites',
            style: TextStyle(
              color: (store.favoriteEpisodesIdList.isNotEmpty)
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
                          Episode episode =
                              store.episodes.results?[index] ?? const Episode();
                          bool isFavorite = store.favoriteEpisodesIdList
                              .contains(episode.id.toString());
                          return CardEpisode(
                            episode: episode,
                            onTap: () async {
                              String episodeId =
                                  store.episodes.results![index].id.toString();
                              List<String> episodeList = store
                                  .favoriteEpisodesIdList
                                  .map((e) => e)
                                  .toList();
                              (isFavorite)
                                  ? episodeList.remove(episodeId)
                                  : episodeList.add(episodeId);
                              await store
                                  .setFavoriteEpisodesIdList(episodeList);
                              await store.saveFavoriteEpisodesLocalStorage();
                            },
                            isFavorite: isFavorite,
                          );
                        },
                        itemCount: store.episodes.results?.length ?? 0,
                      ),
                    ),
                  ),
                  PaginacaoWidget(
                    scrollController: _scrollController,
                    numberPage: store.episodes.info?.pages != null
                        ? "${store.currentPage}/${store.episodes.info?.pages}"
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
                            await store.getEpisodes();
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
                            await store.getEpisodes();
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
