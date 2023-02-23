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
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elo7.com.br%2Fbig-poster-filme-aladdin-2019-lo01-tamanho-90x60-cm%2Fdp%2FF6DFED&psig=AOvVaw1XhxFqfHeNJFkQg3B_3sTv&ust=1677246042946000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjglMfiq_0CFQAAAAAdAAAAABAD",
      "premiere_date": "2018-12-10",
      "classification": "L",
      "director": "Desconhecido",
      "additional": [],
      "type_movie": ["favorite"],
    },
    {
      "name": "Capitã Marvel",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elo7.com.br%2Fbig-poster-filme-capita-marvel-tamanho-90x60-cm%2Fdp%2FDF057F&psig=AOvVaw1XhxFqfHeNJFkQg3B_3sTv&ust=1677246042946000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjglMfiq_0CFQAAAAAdAAAAABAS",
      "premiere_date": "2020-12-18",
      "classification": "16",
      "director": "Disney",
      "additional": [],
      "type_movie": ["action"],
    },
    {
      "name": "Batman",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmarriedgames.com.br%2Fnoticias%2Fthe-batman%2F&psig=AOvVaw1XhxFqfHeNJFkQg3B_3sTv&ust=1677246042946000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjglMfiq_0CFQAAAAAdAAAAABAm",
      "premiere_date": "2022-12-18",
      "classification": "18",
      "director": "DC",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Senhor dos aneis",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.showmetech.com.br%2Fposteres-de-filmes-alta-resolucao%2F&psig=AOvVaw1XhxFqfHeNJFkQg3B_3sTv&ust=1677246042946000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjglMfiq_0CFQAAAAAdAAAAABA6",
      "premiere_date": "2002-12-18",
      "classification": "14",
      "director": "Desconhecido",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Bacurau",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmedium.com%2Frevista-bravo%2Fo-cartaz-de-cinema-como-obra-de-arte-231b2d395043&psig=AOvVaw1XhxFqfHeNJFkQg3B_3sTv&ust=1677246042946000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjglMfiq_0CFQAAAAAdAAAAABBO",
      "premiere_date": "2018-12-18",
      "classification": "18",
      "director": "Desconhecido",
      "additional": ["Indicado ao Oscar"],
      "type_movie": ["action"],
    },
    {
      "name": "Uncharted",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Ftecmasters.com.br%2Ffilme-uncharted-poster-imagens-ineditas%2F&psig=AOvVaw1XhxFqfHeNJFkQg3B_3sTv&ust=1677246042946000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOjglMfiq_0CFQAAAAAdAAAAABBs",
      "premiere_date": "2022-12-18",
      "classification": "14",
      "director": "Tom",
      "additional": [],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Avatar",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elo7.com.br%2Fbig-poster-filme-avatar-o-caminho-da-agua-90x60-cm-lo002%2Fdp%2F1B052A2&psig=AOvVaw0--48RAFHTI5FKBM2din9h&ust=1677246015159000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCPDc87riq_0CFQAAAAAdAAAAABAD",
      "premiere_date": "2009-12-18",
      "classification": "14",
      "director": "James Cameron",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Avatar",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elo7.com.br%2Fbig-poster-filme-avatar-o-caminho-da-agua-90x60-cm-lo002%2Fdp%2F1B052A2&psig=AOvVaw0--48RAFHTI5FKBM2din9h&ust=1677246015159000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCPDc87riq_0CFQAAAAAdAAAAABAD",
      "premiere_date": "2009-12-18",
      "classification": "14",
      "director": "James Cameron",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Avatar",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elo7.com.br%2Fbig-poster-filme-avatar-o-caminho-da-agua-90x60-cm-lo002%2Fdp%2F1B052A2&psig=AOvVaw0--48RAFHTI5FKBM2din9h&ust=1677246015159000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCPDc87riq_0CFQAAAAAdAAAAABAD",
      "premiere_date": "2009-12-18",
      "classification": "14",
      "director": "James Cameron",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
    {
      "name": "Avatar",
      "poster":
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.elo7.com.br%2Fbig-poster-filme-avatar-o-caminho-da-agua-90x60-cm-lo002%2Fdp%2F1B052A2&psig=AOvVaw0--48RAFHTI5FKBM2din9h&ust=1677246015159000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCPDc87riq_0CFQAAAAAdAAAAABAD",
      "premiere_date": "2009-12-18",
      "classification": "14",
      "director": "James Cameron",
      "additional": ["Oscar"],
      "type_movie": ["favorite", "action"],
    },
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
