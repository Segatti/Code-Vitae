import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../../domain/entities/location.dart';
import '../stores/all_locations_store.dart';
import '../widgets/card_location.dart';

class AllLocationsPage extends StatefulWidget {
  const AllLocationsPage({super.key});

  @override
  State<AllLocationsPage> createState() => _AllLocationsPageState();
}

class _AllLocationsPageState extends State<AllLocationsPage> {
  late AllLocationsStore store;
  final ScrollController _scrollController = ScrollController();
  late CupertinoThemeData theme;
  late TextStyle textStyleTheme;

  @override
  void initState() {
    store = Modular.get<AllLocationsStore>();
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
          Location location =
              store.locations.results?[index] ?? const Location();
          bool isFavorite =
              store.favoriteLocationsIdList.contains(location.id.toString());
          return CardLocation(
            location: location,
            onTap: () async {
              String locationId = store.locations.results![index].id.toString();
              List<String> locationList =
                  store.favoriteLocationsIdList.map((e) => e).toList();
              (isFavorite)
                  ? locationList.remove(locationId)
                  : locationList.add(locationId);
              await store.setFavoriteLocationsIdList(locationList);
              await store.saveFavoriteLocationsLocalStorage();
            },
            isFavorite: isFavorite,
          );
        },
        itemCount: store.locations.results?.length ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = CupertinoTheme.of(context);
    textStyleTheme = theme.textTheme.textStyle;

    return BasePageWidget(
      title: 'Locations',
      padding: EdgeInsets.zero,
      trailing: Observer(builder: (context) {
        return GestureDetector(
          onTap: (store.favoriteLocationsIdList.isNotEmpty)
              ? () {
                  Modular.to.pushNamed('/favorites/locations');
                }
              : null,
          child: Text(
            'Favorites',
            style: TextStyle(
              color: (store.favoriteLocationsIdList.isNotEmpty)
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
                                  await store.getLocations();
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
                        (store.locations.info?.pages != null)
                            ? Text(
                                "${store.currentPage}/${store.locations.info?.pages}")
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
                                  await store.getLocations();
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
