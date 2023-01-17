import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/margin_pattern.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/app_bar_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/bottom_navigation_bar_widget.dart';

import '../../../../core/domain/entities/page_states.dart';
import '../stores/all_characters_store.dart';

class AllCharactersPage extends StatefulWidget {
  const AllCharactersPage({super.key});

  @override
  State<AllCharactersPage> createState() => _AllCharactersPageState();
}

class _AllCharactersPageState extends State<AllCharactersPage> {
  late AllCharactersStore store;

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
    return Scaffold(
      appBar: const AppBarWidget(title: 'Dimension C-131'),
      body: BasePageWidget(
        child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (context) => (store.pageState == LoadingState())
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Text(
                              "${store.currentPage}/${store.characters.info?.pages}"),
                          const SizedBox(height: MarginPattern.medium),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (_, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5.0,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      side: BorderSide(
                                        width: 2,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: CachedNetworkImage(
                                              imageUrl: store.characters
                                                      .results?[index].image ??
                                                  '',
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 150,
                                              padding: const EdgeInsets.all(
                                                PaddingPattern.small,
                                              ),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    store
                                                            .characters
                                                            .results?[index]
                                                            .name ??
                                                        '',
                                                    maxLines: 2,
                                                    minFontSize: 18,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  AutoSizeText(
                                                    "Origin: ${store.characters.results?[index].origin?.name ?? ''}",
                                                    maxLines: 2,
                                                  ),
                                                  AutoSizeText(
                                                    "Species: ${store.characters.results?[index].species ?? ''}",
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: MarginPattern.small,
                                  ),
                                  child: const Divider(
                                    color: Colors.amber,
                                    thickness: 2,
                                  ),
                                );
                              },
                              itemCount: store.characters.results?.length ?? 0,
                            ),
                          ),
                          const SizedBox(height: MarginPattern.medium),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed:
                                      (store.characters.info?.prev != null)
                                          ? () async {
                                              store.setCurrentPage(
                                                  store.currentPage - 1);
                                              await store.getCharacters();
                                            }
                                          : null,
                                  child: const Text('Prev'),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed:
                                      (store.characters.info?.next != null)
                                          ? () async {
                                              store.setCurrentPage(
                                                  store.currentPage + 1);
                                              await store.getCharacters();
                                            }
                                          : null,
                                  child: const Text('Next'),
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
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(
        initialValue: 0,
      ),
    );
  }
}
