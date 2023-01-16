import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? buttons;
  const AppBarWidget({
    super.key,
    required this.title,
    this.buttons,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SafeArea(
        child: Text(
          title,
        ),
      ),
      centerTitle: true,
      actions: buttons,
      backgroundColor: Colors.black45,
    );
  }
}
