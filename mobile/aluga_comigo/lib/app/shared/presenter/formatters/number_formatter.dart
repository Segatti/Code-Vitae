import 'package:flutter/services.dart';

class NumberFormatter extends TextInputFormatter {
  final bool allowDecimal;

  NumberFormatter({this.allowDecimal = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Se permitir decimais
    if (allowDecimal) {
      // Regex para permitir apenas números com, no máximo, um ponto decimal
      final validText = RegExp(r'^\d*\.?\d*$');

      // Se o texto for válido, mantenha, caso contrário, retorne o valor antigo
      if (validText.hasMatch(text)) {
        return TextEditingValue(
          text: (newValue.text.startsWith("."))
              ? double.parse(newValue.text).toString()
              : newValue.text,
          selection: TextSelection.collapsed(
            offset: (newValue.text.startsWith("."))
                ? double.parse(newValue.text).toString().length
                : newValue.text.length,
          ),
        );
      } else {
        return oldValue;
      }
    } else {
      // Permitir apenas números inteiros
      final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
      return TextEditingValue(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
    }
  }
}
