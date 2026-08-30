import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract final class AppTransitions {
  static const rightToLeft = CustomTransition(
    duration: Duration(milliseconds: 500),
    transitionsBuilder: _slideFromRight,
  );

  static const upToDown = CustomTransition(
    transitionsBuilder: _slideFromTop,
  );

  static Widget _slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: child,
    );
  }

  static Widget _slideFromTop(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(0, -1), end: Offset.zero),
      ),
      child: child,
    );
  }
}
