import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TabsWidget extends StatelessWidget {
  final List<String> values;
  final int valueSelected;
  final Function(int value) onChange;

  const TabsWidget({
    super.key,
    required this.values,
    required this.onChange,
    required this.valueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
      decoration: BoxDecoration(
        color: const Color(0xFF646464),
        borderRadius: BorderRadius.circular(40),
      ),
      thumbDecoration: BoxDecoration(
        color: const Color(0xFFDF924B),
        borderRadius: BorderRadius.circular(40),
      ),
      onValueChanged: (int? value) async {
        if (value != null) {
          await onChange(value);
        }
      },
      innerPadding: const EdgeInsets.all(5),
      children: <int, Widget>{
        for (int i = 0; i < values.length; i++)
          i: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              values[i],
              textScaler: const TextScaler.linear(1),
              style: GoogleFonts.rubik(
                color: CupertinoColors.white,
                fontSize: 16,
              ),
            ),
          ),
      },
    );
  }
}
