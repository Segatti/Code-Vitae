import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

import '../../../../core/domain/entities/page_states.dart';
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
      return ListView.builder(
        controller: _scrollController,
        itemBuilder: (_, index) {
          Episode episode =
              store.episodes.results?[index] ?? const Episode();
          bool isFavorite =
              store.favoriteEpisodesIdList.contains(episode.id.toString());
          return CardEpisode(
            episode: episode,
            onTap: () async {
              String episodeId =
                  store.episodes.results![index].id.toString();
              List<String> episodeList =
                  store.favoriteEpisodesIdList.map((e) => e).toList();
              (isFavorite)
                  ? episodeList.remove(episodeId)
                  : episodeList.add(episodeId);
              await store.setFavoriteEpisodesIdList(episodeList);
              await store.saveFavoriteEpisodesLocalStorage();
            },
            isFavorite: isFavorite,
          );
        },
        itemCount: store.episodes.results?.length ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    textStyleTheme = theme.textTheme.textStyle;

    return BasePageWidget(
      title: 'Episodes',
      padding: EdgeInsets.zero,
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
          Modular.to.pushNamed('/favorites/episodes');
        },
      ),
      child: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (context) => Column(
                children: [
                  Expanded(child: buildState(store.pageState)),
                  Container(
                    color: CupertinoColors.black.withOpacity(.25),
                    height: 1,
                    width: double.maxFinite,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingPattern.small,
                      vertical: PaddingPattern.medium,
                    ),
                    child: Row(
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
                                  await store.getEpisodes();
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
                        (store.episodes.info?.pages != null)
                            ? Text(
                                "${store.currentPage}/${store.episodes.info?.pages}")
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
                                  await store.getEpisodes();
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
