import 'dart:async';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv/app/shared/utils/color_pattern.dart';

class ButtonPrimary extends StatefulWidget {
  final String title;
  final Function onClick;
  const ButtonPrimary({
    super.key,
    required this.title,
    required this.onClick,
  });

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  Timer? timer;
  bool focus = false;

  @override
  Widget build(BuildContext context) {
    return DpadContainer(
      onClick: () {
        if (timer?.isActive ?? false) timer?.cancel();
        timer = Timer(const Duration(milliseconds: 500), () {
          widget.onClick();
        });
      },
      onFocus: (isFocused) {
        setState(() {
          focus = isFocused;
        });
      },
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(ColorPattern.primaryColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                width: 3,
                color: ColorPattern.primaryColor,
              ),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(
          widget.title,
          style: TextStyle(
            color: focus ? Colors.amber : Colors.white,
          ),
        ),
      ),
    );
  }
}
