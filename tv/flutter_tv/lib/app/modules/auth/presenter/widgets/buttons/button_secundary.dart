import 'dart:async';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv/app/shared/utils/color_pattern.dart';

class ButtonSecundary extends StatefulWidget {
  final String title;
  final Function onClick;
  const ButtonSecundary({
    super.key,
    required this.title,
    required this.onClick,
  });

  @override
  State<ButtonSecundary> createState() => _ButtonSecundaryState();
}

class _ButtonSecundaryState extends State<ButtonSecundary> {
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
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
