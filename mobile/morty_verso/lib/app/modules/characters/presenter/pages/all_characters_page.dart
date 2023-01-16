import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    return Container();
  }
}
