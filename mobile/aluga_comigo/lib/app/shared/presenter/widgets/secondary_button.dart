import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color colorTapEffect;

  const SecondaryButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    this.height = 50,
    this.colorTapEffect = Colors.blue,
    this.width,
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
            width: width,
            padding: padding,
            backgroundColor: const Color(0xFF2C29A3),
            borderRadius: 50,
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
