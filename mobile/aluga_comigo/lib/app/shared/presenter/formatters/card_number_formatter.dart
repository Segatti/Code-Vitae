import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove todos os espaços
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Adiciona espaços a cada 4 dígitos
    String formattedText = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += digitsOnly[i];
    }

    // Mantém a posição do cursor
    int cursorPosition = formattedText.length;
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}