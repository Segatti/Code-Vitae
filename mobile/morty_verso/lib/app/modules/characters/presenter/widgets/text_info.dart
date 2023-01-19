import 'package:flutter/material.dart';
import 'package:morty_verso/app/core/utils/strings.dart';

import '../../../../core/domain/patterns/padding_pattern.dart';

class TextInfo extends StatelessWidget {
  final String keyValue;
  final String value;
  const TextInfo({super.key, required this.keyValue, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Expanded(child: LayoutBuilder(
              builder: (_, constrains) {
                return Row(
                  children: [
                    Container(
                      width: constrains.maxWidth * 0.3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: PaddingPattern.medium,
                        vertical: PaddingPattern.small,
                      ),
                      color: Colors.grey,
                      child: Text(
                        keyValue,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: PaddingPattern.medium),
                      child: Text(
                        validText(value),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
