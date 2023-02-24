import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/filmes.dart';
import '../stores/main_store.dart';
import '../widgets/card_movie.dart';
import '../widgets/movie_infos.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainStore store;

  Timer? timer;

  @override
  void initState() {
    store = Modular.get<MainStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lista de filmes
          Container(
            padding: const EdgeInsets.all(32),
            color: const Color(0xFF01012B),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                const Text(
                  "Catálogo de filmes",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 185,
                        child: DottedBorder(
                          color: const Color.fromARGB(63, 255, 255, 255),
                          strokeWidth: 3,
                          dashPattern: const [6, 6],
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: filmes.length,
                            itemBuilder: (BuildContext _, int index) =>
                                Observer(builder: (context) {
                              return CardMovie(
                                hover: store.itemFocus == index,
                                urlImage: filmes[index]['poster'],
                                onFocus: () => store.setItemFocus(index),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          // Logo topo
          Row(
            children: [Expanded(child: Image.asset('assets/topo.png'))],
          ),
          // Infos em baixo
          Observer(
            builder: (context) => (store.itemFocus != null)
                ? MovieInfos(movie: filmes[store.itemFocus!])
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
