import 'dart:async';

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';

import '../../../../shared/utils/color_pattern.dart';

class InputForm extends StatefulWidget {
  final String title;
  final Function(String value) saveValue;
  final bool obscureText;
  const InputForm({
    super.key,
    this.obscureText = false,
    required this.saveValue,
    required this.title,
  });

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  Timer? timer;
  FocusNode focusInput = FocusNode();
  bool focus = false;
  bool click = false;
  final TextEditingController _controller = TextEditingController(text: "");

  String generateTextSenha(int lenghtSenha) {
    String senhaOculta = "";
    for (int i = 0; i < lenghtSenha; i++) {
      senhaOculta += "*";
    }
    return senhaOculta;
  }

  @override
  Widget build(BuildContext context) {
    return DpadContainer(
      onClick: () {
        if (timer?.isActive ?? false) timer?.cancel();
        timer = Timer(const Duration(milliseconds: 500), () {
          setState(() {
            click = true;
          });
          focusInput.requestFocus();
        });
      },
      onFocus: (isFocused) {
        setState(() {
          focus = isFocused;
        });
      },
      child: Container(
        height: 44,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                focus ? ColorPattern.primaryColor : ColorPattern.secudaryColor,
            width: 3,
          ),
        ),
        child: click
            ? TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _controller,
                focusNode: focusInput,
                onEditingComplete: () {
                  setState(() {
                    click = false;
                  });
                  widget.saveValue(_controller.text);
                },
                obscureText: widget.obscureText,
              )
            : Text(
                _controller.text.isEmpty
                    ? widget.title
                    : (widget.obscureText)
                        ? generateTextSenha(
                            _controller.text.length,
                          )
                        : _controller.text,
                style: TextStyle(
                  color: focus ? Colors.amber : Colors.white,
                ),
              ),
      ),
    );
  }
}
