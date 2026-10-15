import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/enums/ticket_category.dart';

class TicketCategoryChip extends StatelessWidget {
  const TicketCategoryChip({super.key, required this.category});

  final TicketCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C29A3).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.label,
        style: GoogleFonts.rubik(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2C29A3),
        ),
      ),
    );
  }
}
