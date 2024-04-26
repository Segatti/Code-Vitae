import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/models/select_item.dart';

class PillWidget extends StatefulWidget {
  final SelectItem selectItem;
  final bool? initialValue;
  final Function(bool isSelected, SelectItem value) onTap;
  const PillWidget({
    super.key,
    required this.selectItem,
    required this.onTap,
    this.initialValue = false,
  });

  @override
  State<PillWidget> createState() => _PillWidgetState();
}

class _PillWidgetState extends State<PillWidget> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onTap(isSelected, widget.selectItem);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSelected ? const Color(0xFFDF924B) : Colors.white,
          border: Border.all(
            color:
                isSelected ? const Color(0xFFDF924B) : const Color(0xFF8B8B8B),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          widget.selectItem.title ?? '',
          textScaler: const TextScaler.linear(1),
          maxLines: 1,
          style: GoogleFonts.rubik(
            color: !isSelected ? Colors.black : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
