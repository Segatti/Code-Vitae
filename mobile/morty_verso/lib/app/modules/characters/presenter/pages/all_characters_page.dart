import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/icon_pattern.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/app_bar_widget.dart';
import 'package:morty_verso/app/core/presenter/widgets/view/base_page_widget.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'All Characters'),
      body: BasePageWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: Image.asset(IconPattern.logo),
            ),
          ],
        ),
      ),
    );
  }
}
