import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class PowerUpBadge extends StatelessWidget {
  const PowerUpBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A50), Color(0xFFFF5722)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.rocket_launch_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'PowerUp',
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
