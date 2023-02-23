import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
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

  Timer? timer;

  List<Map<String, dynamic>> filmes = [
    {
      "name": "Avatar",
      "poster":
          "https://img.elo7.com.br/product/zoom/46B928F/big-poster-filme-avatar-o-caminho-da-agua-90x60-cm-lo002-presente-geek.jpg",
      "premiere_date": "2009-12-18",
      "classification": "14",
      "director": "James Cameron",
      "sinopse":
          "No exuberante mundo alienígena de Pandora vivem os Na'vi, seres que parecem ser primitivos, mas são altamente evoluídos. Como o ambiente do planeta é tóxico, foram criados os avatares, corpos biológicos controlados pela mente humana que se movimentam livremente em Pandora. Jake Sully, um ex-fuzileiro naval paralítico, volta a andar através de um avatar e se apaixona por uma Na'vi. Esta paixão leva Jake a lutar pela sobrevivência de Pandora.",
    },
    {
      "name": "Aladin",
      "poster":
          "https://img.elo7.com.br/product/zoom/2747CBC/big-poster-filme-aladdin-2019-lo01-tamanho-90x60-cm-nerd.jpg",
      "premiere_date": "2018-12-10",
      "classification": "L",
      "director": "Desconhecido",
      "sinopse":
          "Um jovem humilde descobre uma lâmpada mágica com um gênio que pode conceder desejos. Agora, o rapaz quer conquistar a moça por quem se apaixonou, mas o que ele não sabe é que a jovem é uma princesa que já está comprometida. Com a ajuda do gênio, ele tenta se passar por um príncipe para fisgar o amor da moça e a confiança de seu pai.",
    },
    {
      "name": "Capitã Marvel",
      "poster":
          "https://img.elo7.com.br/product/zoom/23646C7/big-poster-filme-capita-marvel-tamanho-90x60-cm-presente-geek.jpg",
      "premiere_date": "2020-12-18",
      "classification": "16",
      "director": "Disney",
      "sinopse":
          "Capitã Marvel, parte do exército de elite dos Kree, uma raça alienígena, encontra-se no meio de uma batalha entre seu povo e os Skrulls. Ao tentar impedir uma invasão de larga escala na Terra, em 1995, ela tem memórias recorrentes de uma outra vida, como Carol Danvers, agente da Força Aérea norte-americana. Com a ajuda de Nick Fury, Capitã Marvel precisa descobrir os segredos de seu passado e pôr um fim ao conflito intergalático com os Skrulls.",
    },
    {
      "name": "Batman",
      "poster":
          "https://img.elo7.com.br/product/zoom/3FBA809/big-poster-filme-batman-2022-90x60-cm-lo002-poster-batman.jpg",
      "premiere_date": "2022-12-18",
      "classification": "18",
      "director": "DC",
      "sinopse":
          "Após dois anos espreitando as ruas como Batman, Bruce Wayne se encontra nas profundezas mais sombrias de Gotham City. Com poucos aliados confiáveis, o vigilante solitário se estabelece como a personificação da vingança para a população.",
    },
    {
      "name": "Senhor dos aneis",
      "poster":
          "https://img.elo7.com.br/product/zoom/269274A/poster-o-senhor-dos-aneis-a-sociedade-do-anel-lo04-90x60-cm-presente-geek.jpg",
      "premiere_date": "2002-12-18",
      "classification": "14",
      "director": "Desconhecido",
      "sinopse":
          "Em uma terra fantástica e única, um hobbit recebe de presente de seu tio um anel mágico e maligno que precisa ser destruído antes que caia nas mãos do mal. Para isso, o hobbit Frodo tem um caminho árduo pela frente, onde encontra perigo, medo e seres bizarros. Ao seu lado para o cumprimento desta jornada, ele aos poucos pode contar com outros hobbits, um elfo, um anão, dois humanos e um mago, totalizando nove seres que formam a Sociedade do Anel.",
    },
    {
      "name": "Bacurau",
      "poster":
          "https://br.web.img3.acsta.net/r_1920_1080/pictures/19/07/23/23/24/0636548.jpg",
      "premiere_date": "2018-12-18",
      "classification": "18",
      "director": "Desconhecido",
      "sinopse":
          "Num futuro não muito longínquo, uma povoação de nome Bacurau, em pleno sertão brasileiro, some misteriosamente do mapa. Quando uma série de assassinatos inexplicáveis começam a acontecer, os moradores da cidade tentam reagir. Mas como se podem defender de um inimigo desconhecido e implacável?",
    },
    {
      "name": "Uncharted",
      "poster":
          "https://img.elo7.com.br/product/zoom/3FBBEF2/big-poster-filme-uncharted-2022-90x60-cm-lo002-poster-de-filme.jpg",
      "premiere_date": "2022-12-18",
      "classification": "14",
      "director": "Tom",
      "sinopse":
          "Nathan Drake e seu parceiro canastrão Victor 'Sully' Sullivan embarcam em uma perigosa busca para encontrar o maior tesouro jamais encontrado. Enquanto isso, eles também rastreiam pistas que podem levar ao irmão perdido de Nathan.",
    },
    {
      "name": "Harry Potter",
      "poster":
          "https://img.elo7.com.br/product/zoom/2657658/big-poster-harry-potter-e-as-reliquias-da-morte-lo04-90x60-poster-cinema.jpg",
      "premiere_date": "2018-12-18",
      "classification": "16",
      "director": "J. K. Rowling",
      "sinopse":
          "Harry Potter é uma série de sete romances de fantasia escrita pela autora britânica J. K. Rowling. A série narra as aventuras de um jovem chamado Harry James Potter, que descobre aos 11 anos de idade que é um bruxo ao ser convidado para estudar na Escola de Magia e Bruxaria de Hogwarts.",
    },
    {
      "name": "Stranger Things",
      "poster":
          "https://img.elo7.com.br/product/zoom/3041510/big-poster-serie-stranger-things-netflix-lo001-90x60-cm-geek.jpg",
      "premiere_date": "2018-02-10",
      "classification": "16",
      "director": "Ross Duffer",
      "sinopse":
          "Um grupo de amigos se envolve em uma série de eventos sobrenaturais na pacata cidade de Hawkins. Eles enfrentam criaturas monstruosas, agências secretas do governo e se aventuram em dimensões paralelas.",
    }
  ];

  @override
  void initState() {
    store = Modular.get<MainStore>();
    super.initState();
  }

  String dateFormat(String date) {
    List data = date.split('-');
    String day = data.last;
    String month = data[1];
    String year = data.first;
    return "$day/$month/$year";
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
                            itemBuilder: (BuildContext context, int index) =>
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
                                    store.setListFocus("favorite");
                                    store.setItemFocus(filmes.indexWhere(
                                        (element) => filmes[index] == element));
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
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFD9D9D9),
                            Color(0x00D9D9D9),
                          ],
                        ),
                      ),
                      child: Observer(
                        builder: (context) {
                          return Row(
                            children: [
                              CachedNetworkImage(
                                height: 180,
                                width: 115,
                                imageUrl: filmes[store.itemFocus!]['poster'],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${filmes[store.itemFocus!]['name']}",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Diretor: ${filmes[store.itemFocus!]['director']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Classificação: ${(filmes[store.itemFocus!]['classification'] == 'L') ? 'Livre' : '${filmes[store.itemFocus!]['classification']} anos'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Lançamento: ${dateFormat(filmes[store.itemFocus!]['premiere_date'])}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.white,
                                  child: Column(children: [
                                    const Text(
                                      "Sinopse",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AutoSizeText(
                                      "${filmes[store.itemFocus!]['sinopse']}",
                                      softWrap: true,
                                      maxLines: 6,
                                    ),
                                  ]),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
