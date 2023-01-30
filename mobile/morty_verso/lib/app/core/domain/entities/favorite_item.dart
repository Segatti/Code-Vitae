import 'package:flutter/cupertino.dart';

class FavoriteItem {
  final String title;
  final String info1;
  final String info2;
  final String image;
  final Widget? icon;

  const FavoriteItem({
    required this.title,
    required this.info1,
    required this.info2,
    required this.image,
    this.icon,
  });
}
