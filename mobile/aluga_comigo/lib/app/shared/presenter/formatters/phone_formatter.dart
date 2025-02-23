import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remover caracteres não numéricos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limitar a quantidade de caracteres a 11 (00011122233)
    final truncated = digitsOnly.substring(0, digitsOnly.length.clamp(0, 11));

    var textFinal = "";
    if (truncated.length <= 2) {
      textFinal = truncated;
    } else if (truncated.length <= 6) {
      textFinal = "(${truncated.substring(0, 2)}) ${truncated.substring(2)}";
    } else if (truncated.length <= 10) {
      textFinal =
          "(${truncated.substring(0, 2)}) ${truncated.substring(2, 6)}-${truncated.substring(6)}";
    } else {
      textFinal =
          "(${truncated.substring(0, 2)}) ${truncated.substring(2, 7)}-${truncated.substring(7)}";
    }

    return TextEditingValue(
      text: textFinal,
      selection: TextSelection.collapsed(offset: textFinal.length),
    );
  }
}
