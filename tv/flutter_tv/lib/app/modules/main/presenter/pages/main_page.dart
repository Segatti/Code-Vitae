import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tv/app/modules/main/presenter/stores/main_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainStore store;
  final favoriteKey = GlobalKey();
  final actionKey = GlobalKey();

  List<Map<String, dynamic>> filmes = [
    {
      "name": "Avatar",
      "poster":
          "https://img.elo7.com.br/product/zoom/46B928F/big-poster-filme-avatar-o-caminho-da-agua-90x60-cm-lo002-presente-geek.jpg",
      "premiere_date": "2009-12-18",
      "classification": "14",
      "director": "James Cameron",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Aladin",
      "poster":
          "https://img.elo7.com.br/product/zoom/2747CBC/big-poster-filme-aladdin-2019-lo01-tamanho-90x60-cm-nerd.jpg",
      "premiere_date": "2018-12-10",
      "classification": "L",
      "director": "Desconhecido",
      "additional": [],
      "type_movie": ["favorite"],
    },
    {
      "name": "Capitã Marvel",
      "poster":
          "https://img.elo7.com.br/product/zoom/23646C7/big-poster-filme-capita-marvel-tamanho-90x60-cm-presente-geek.jpg",
      "premiere_date": "2020-12-18",
      "classification": "16",
      "director": "Disney",
      "additional": [],
      "type_movie": ["action"],
    },
    {
      "name": "Batman",
      "poster":
          "https://img.elo7.com.br/product/zoom/3FBA809/big-poster-filme-batman-2022-90x60-cm-lo002-poster-batman.jpg",
      "premiere_date": "2022-12-18",
      "classification": "18",
      "director": "DC",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Senhor dos aneis",
      "poster":
          "https://img.elo7.com.br/product/zoom/269274A/poster-o-senhor-dos-aneis-a-sociedade-do-anel-lo04-90x60-cm-presente-geek.jpg",
      "premiere_date": "2002-12-18",
      "classification": "14",
      "director": "Desconhecido",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Bacurau",
      "poster":
          "https://br.web.img3.acsta.net/r_1920_1080/pictures/19/07/23/23/24/0636548.jpg",
      "premiere_date": "2018-12-18",
      "classification": "18",
      "director": "Desconhecido",
      "additional": ["Indicado ao Oscar"],
      "type_movie": ["action"],
    },
    {
      "name": "Uncharted",
      "poster":
          "https://img.elo7.com.br/product/zoom/3FBBEF2/big-poster-filme-uncharted-2022-90x60-cm-lo002-poster-de-filme.jpg",
      "premiere_date": "2022-12-18",
      "classification": "14",
      "director": "Tom",
      "additional": [],
      "type_movie": ["favorite", "action"],
    }
  ];

  @override
  void initState() {
    store = Modular.get<MainStore>();
    super.initState();
  }

  Future scrollToItem(GlobalKey itemKey) async {
    final context = itemKey.currentContext!;
    await Scrollable.ensureVisible(context, alignment: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lista de filmes
          Container(
            color: const Color(0xFF01012B),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 96),
                  Row(
                    children: const [
                      SizedBox(width: 32),
                      Text(
                        "Favoritos",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DpadContainer(
                    onClick: () {},
                    onFocus: (isFocused) {
                      store.setListFocus("favorite");
                      scrollToItem(favoriteKey);
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 32),
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
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Observer(builder: (context) {
                                  return Container(
                                    width: (store.listFocus == "favorite" &&
                                            store.itemFocus ==
                                                filmes.indexWhere((element) =>
                                                    element == filmes[index]))
                                        ? 120
                                        : 115,
                                    height: (store.listFocus == "favorite" &&
                                            store.itemFocus ==
                                                filmes.indexWhere((element) =>
                                                    element == filmes[index]))
                                        ? 185
                                        : 170,
                                    padding: (store.listFocus == "favorite" &&
                                            store.itemFocus ==
                                                filmes.indexWhere((element) =>
                                                    element == filmes[index]))
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.all(8),
                                    child: DpadContainer(
                                      onClick: () {},
                                      child: Card(
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            (store.listFocus == "favorite" &&
                                                    store.itemFocus ==
                                                        filmes.indexWhere(
                                                            (element) =>
                                                                element ==
                                                                filmes[index]))
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255,
                                                    180,
                                                    180,
                                                    180,
                                                  ),
                                            BlendMode.modulate,
                                          ),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: filmes[index]["poster"],
                                          ),
                                        ),
                                      ),
                                      onFocus: (isFocused) {
                                        store.setItemFocus(filmes.indexWhere(
                                            (element) =>
                                                filmes[index] == element));
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: const [
                      SizedBox(width: 32),
                      Text(
                        "Ação",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DpadContainer(
                    onClick: () {},
                    onFocus: (isFocused) {
                      store.setListFocus("action");
                      scrollToItem(actionKey);
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 32),
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
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Observer(builder: (context) {
                                  return Container(
                                    width: (store.listFocus == "action" &&
                                            store.itemFocus ==
                                                filmes.indexWhere((element) =>
                                                    element == filmes[index]))
                                        ? 120
                                        : 115,
                                    height: (store.listFocus == "action" &&
                                            store.itemFocus ==
                                                filmes.indexWhere((element) =>
                                                    element == filmes[index]))
                                        ? 185
                                        : 170,
                                    padding: (store.listFocus == "action" &&
                                            store.itemFocus ==
                                                filmes.indexWhere((element) =>
                                                    element == filmes[index]))
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.all(8),
                                    child: DpadContainer(
                                      onClick: () {},
                                      child: Card(
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            (store.listFocus == "action" &&
                                                    store.itemFocus ==
                                                        filmes.indexWhere(
                                                            (element) =>
                                                                element ==
                                                                filmes[index]))
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255,
                                                    180,
                                                    180,
                                                    180,
                                                  ),
                                            BlendMode.modulate,
                                          ),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: filmes[index]["poster"],
                                          ),
                                        ),
                                      ),
                                      onFocus: (isFocused) {
                                        store.setItemFocus(filmes.indexWhere(
                                            (element) =>
                                                filmes[index] == element));
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 96),
                ],
              ),
            ),
          ),
          // Logo topo
          // Infos em baixo
        ],
      ),
    );
  }
}
