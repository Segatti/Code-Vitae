import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TerciaryButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color colorTitle;
  final Widget? prefixIcon;
  final Color colorInside;
  final double height;

  const TerciaryButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.colorTitle,
    this.prefixIcon,
    this.colorInside = const Color(0xFF24272C),
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: colorInside,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null)
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: prefixIcon,
                      ),
                    if (prefixIcon != null) const SizedBox(width: 16),
                    Text(
                      title,
                      textScaler: const TextScaler.linear(1),
                      style: GoogleFonts.rubik(
                        color: colorTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
