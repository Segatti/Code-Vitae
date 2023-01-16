import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../stores/character_store.dart';

class CharacterPage extends StatefulWidget {
  final String id;
  const CharacterPage({super.key, required this.id});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late CharacterStore store;

  @override
  void initState() {
    store = Modular.get<CharacterStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
