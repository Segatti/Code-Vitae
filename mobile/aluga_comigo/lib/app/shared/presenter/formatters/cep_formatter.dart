import 'package:flutter/services.dart';

class CepFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remover caracteres não numéricos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limitar a quantidade de caracteres a 8 (00011122233)
    final truncated = digitsOnly.substring(0, digitsOnly.length.clamp(0, 8));

    var textFinal = "";
    if (truncated.length <= 5) {
      textFinal = truncated;
    } else {
      textFinal = "${truncated.substring(0, 5)}-${truncated.substring(5)}";
    }

    return TextEditingValue(
      text: textFinal,
      selection: TextSelection.collapsed(offset: textFinal.length),
    );
  }
}
