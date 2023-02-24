import 'package:cached_network_image/cached_network_image.dart';
import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';

class CardMovie extends StatefulWidget {
  final String urlImage;
  final bool hover;
  final Function onFocus;
  const CardMovie({
    super.key,
    required this.hover,
    required this.urlImage,
    required this.onFocus,
  });

  @override
  State<CardMovie> createState() => _CardMovieState();
}

class _CardMovieState extends State<CardMovie> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.hover ? 120 : 115,
      height: widget.hover ? 185 : 170,
      padding: widget.hover ? const EdgeInsets.all(0) : const EdgeInsets.all(8),
      child: DpadContainer(
        onClick: () {},
        onFocus: (isFocused) => widget.onFocus(),
        child: Card(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              widget.hover
                  ? Colors.white
                  : const Color.fromARGB(255, 180, 180, 180),
              BlendMode.modulate,
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.urlImage,
            ),
          ),
        ),
      ),
    );
  }
}
