import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wear/wear.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const MenuItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) => Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius:
              shape == WearShape.square ? BorderRadius.circular(10) : null,
          shape:
              shape == WearShape.round ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 50,
                  ),
                  const Gap(8),
                  AutoSizeText(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
