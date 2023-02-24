import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieInfos extends StatefulWidget {
  final Map<String, dynamic> movie;
  const MovieInfos({super.key, required this.movie});

  @override
  State<MovieInfos> createState() => _MovieInfosState();
}

class _MovieInfosState extends State<MovieInfos> {

    String dateFormat(String date) {
    List data = date.split('-');
    String day = data.last;
    String month = data[1];
    String year = data.first;
    return "$day/$month/$year";
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: Row(
          children: [
            CachedNetworkImage(
              height: 180,
              width: 115,
              imageUrl: widget.movie['poster'],
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.movie['name']}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Diretor: ${widget.movie['director']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Classificação: ${(widget.movie['classification'] == 'L') ? 'Livre' : '${widget.movie['classification']} anos'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Lançamento: ${dateFormat(widget.movie['premiere_date'])}",
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
                    "${widget.movie['sinopse']}",
                    softWrap: true,
                    maxLines: 6,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
