import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color colorTapEffect;
  const PrimaryButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    this.height = 50,
    this.colorTapEffect = Colors.orange,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: const BoxDecoration(
          color: Color(0xFFDF924B),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: colorTapEffect,
            child: Center(
              child: Text(
                title,
                textScaler: const TextScaler.linear(1),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
