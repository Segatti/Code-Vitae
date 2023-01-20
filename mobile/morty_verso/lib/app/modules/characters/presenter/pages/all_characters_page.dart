import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
        child: RepaintBoundary(child: CircularProgressIndicator()),
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
            child: const Divider(
              color: Colors.amber,
              thickness: 2,
            ),
          );
        },
        itemCount: store.characters.results?.length ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Observer(
            builder: (context) => Column(
              children: [
                (store.characters.info?.pages != null)
                    ? Text(
                        "${store.currentPage}/${store.characters.info?.pages}")
                    : const Text('???'),
                const SizedBox(height: MarginPattern.medium),
                Expanded(child: buildState(store.pageState)),
                const SizedBox(height: MarginPattern.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        onPressed: (store.prevButton)
                            ? () async {
                                _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn,
                                );
                                store.setCurrentPage(store.currentPage - 1);
                                await store.getCharacters();
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.chevron_left),
                            Text('Prev'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        onPressed: (store.nextButton)
                            ? () async {
                                _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn,
                                );
                                store.setCurrentPage(store.currentPage + 1);
                                await store.getCharacters();
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Next'),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
