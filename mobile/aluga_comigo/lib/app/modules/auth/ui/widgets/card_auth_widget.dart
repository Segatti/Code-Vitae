import 'package:flutter/material.dart';

class CardAuthWidget extends StatelessWidget {
  final List<Widget> children;
  const CardAuthWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2C29A3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      width: 330,
      child: Column(
        children: children,
      ),
    );
  }
}
