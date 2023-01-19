// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/entities/page_states.dart';
import 'package:morty_verso/app/core/domain/patterns/font_pattern.dart';
import 'package:morty_verso/app/core/domain/patterns/icon_pattern.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import '../stores/home_store.dart';
import '../widgets/home_favorite.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore store;

  @override
  void initState() {
    store = Modular.get<HomeStore>();
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
      return HomeFavorite(characters: store.favoriteCharactersIdList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 5,
                    offset: Offset(0, 5),
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(PaddingPattern.small),
              child: Image.asset(
                IconPattern.logo,
                cacheHeight: 120,
                cacheWidth: 120,
              ),
            ),
          ],
        ),
        const SizedBox(height: PaddingPattern.big),
        Text(
          'God Morty',
          style: TextStyle(
            fontSize: FontPattern.medium,
          ),
        ),
        const SizedBox(height: PaddingPattern.big),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Occupation: Destroyer',
              style: TextStyle(
                fontSize: FontPattern.small,
              ),
            ),
          ],
        ),
        const SizedBox(height: PaddingPattern.medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Goal: Destroy the universes',
              style: TextStyle(
                fontSize: FontPattern.small,
              ),
            ),
          ],
        ),
        const SizedBox(height: PaddingPattern.big),
        Observer(builder: (context) {
          return buildState(store.pageState);
        }),
      ],
    );
  }
}
