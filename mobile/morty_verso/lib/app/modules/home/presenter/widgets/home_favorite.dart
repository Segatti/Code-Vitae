import 'package:flutter/material.dart';

import '../../../../core/domain/patterns/font_pattern.dart';
import '../../../../core/domain/patterns/padding_pattern.dart';

class HomeFavorite extends StatefulWidget {
  final List<String> characters;
  final Function? generatePDF;
  const HomeFavorite({super.key, required this.characters, this.generatePDF});

  @override
  State<HomeFavorite> createState() => _HomeFavoriteState();
}

class _HomeFavoriteState extends State<HomeFavorite> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      Padding(
                        padding: const EdgeInsets.all(PaddingPattern.small),
                        child: Text(widget.characters.length.toString()),
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
                onPressed: (widget.characters.isNotEmpty)
                    ? () {
                        if (widget.generatePDF != null) {
                          widget.generatePDF!();
                        }
                      }
                    : null,
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
              ),
            ),
          ],
        )
      ],
    );
  }
}
