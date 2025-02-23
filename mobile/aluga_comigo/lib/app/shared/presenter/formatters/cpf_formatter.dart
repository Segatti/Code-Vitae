import 'package:flutter/services.dart';

class CpfFormatter extends TextInputFormatter {
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
    if (truncated.length <= 3) {
      textFinal = truncated;
    } else if (truncated.length <= 6) {
      textFinal = "${truncated.substring(0, 3)}.${truncated.substring(3)}";
    } else if (truncated.length <= 9) {
      textFinal =
          "${truncated.substring(0, 3)}.${truncated.substring(3, 6)}.${truncated.substring(6)}";
    } else {
      textFinal =
          "${truncated.substring(0, 3)}.${truncated.substring(3, 6)}.${truncated.substring(6, 9)}-${truncated.substring(9)}";
    }

    return TextEditingValue(
      text: textFinal,
      selection: TextSelection.collapsed(offset: textFinal.length),
    );
  }
}
