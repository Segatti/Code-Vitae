import 'package:flutter/material.dart';

import '../../../domain/patterns/padding_pattern.dart';

class BasePageWidget extends StatelessWidget {
  final Widget child;
  const BasePageWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingPattern.small,
        vertical: PaddingPattern.medium,
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: child,
        ),
      ),
    );
  }
}
