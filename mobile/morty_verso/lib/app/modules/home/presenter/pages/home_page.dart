// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:morty_verso/app/core/domain/patterns/font_pattern.dart';
import 'package:morty_verso/app/core/domain/patterns/icon_pattern.dart';
import 'package:morty_verso/app/core/domain/patterns/padding_pattern.dart';
import '../stores/home_store.dart';

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
    super.initState();
    store = Modular.get<HomeStore>();
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
                height: 120,
                width: 120,
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
        Row(children: <Widget>[
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: const Divider(
                  color: Colors.black,
                )),
          ),
          Text(
            "Favorites",
            style: TextStyle(
              fontSize: FontPattern.small,
            ),
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: const Divider(
                  color: Colors.black,
                )),
          ),
        ]),
        const SizedBox(height: PaddingPattern.medium),
        LayoutBuilder(
          builder: (_, constrains) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.amber.shade800,
                  width: constrains.maxWidth * 0.3,
                  child: Column(
                    children: [
                      Container(
                        width: constrains.maxWidth * 0.3,
                        height: constrains.maxWidth * 0.3,
                        color: Colors.amber,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.black54,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(PaddingPattern.small),
                        child: Text('0'),
                      ),
                    ],
                  ),
                ),
                // TODO: Fazer as features de locations e episodes
                // Container(
                //   color: Colors.red.shade800,
                //   width: constrains.maxWidth * 0.3,
                //   child: Column(
                //     children: [
                //       Container(
                //         width: constrains.maxWidth * 0.3,
                //         height: constrains.maxWidth * 0.3,
                //         color: Colors.red,
                //         child: const Icon(
                //           Icons.place,
                //           size: 50,
                //           color: Colors.black54,
                //         ),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(PaddingPattern.small),
                //         child: Text('1/126'),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   color: Colors.green.shade800,
                //   width: constrains.maxWidth * 0.3,
                //   child: Column(
                //     children: [
                //       Container(
                //         width: constrains.maxWidth * 0.3,
                //         height: constrains.maxWidth * 0.3,
                //         color: Colors.green,
                //         child: const Icon(
                //           Icons.play_circle_filled,
                //           size: 50,
                //           color: Colors.black54,
                //         ),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(PaddingPattern.small),
                //         child: Text('1/51'),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
        const SizedBox(height: PaddingPattern.big),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Share favorites',
                      style: TextStyle(
                        fontSize: FontPattern.small,
                      ),
                    ),
                    const Icon(Icons.share),
                  ],
                ),
                onPressed: () {
                  // TODO: Gerar PDF com os itens favoritados
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
