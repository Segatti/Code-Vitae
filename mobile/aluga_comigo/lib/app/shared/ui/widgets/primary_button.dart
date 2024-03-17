import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final double borderRadius;
  const PrimaryButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    this.height = 50,
    this.color = const Color(0xFFDF924B),
    this.borderRadius = 50,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ChicletAnimatedButton(
            onPressed: onTap,
            height: height,
            padding: padding,
            backgroundColor: color,
            borderRadius: borderRadius,
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
      ],
    );
  }
}
