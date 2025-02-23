import 'package:flutter/services.dart';

class CnpjFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remover caracteres não numéricos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limitar a quantidade de caracteres a 14 (00.000.000/0000-00)
    final truncated = digitsOnly.substring(0, digitsOnly.length.clamp(0, 14));

    var textFinal = "";
    if (truncated.length <= 2) {
      textFinal = truncated;
    } else if (truncated.length <= 5) {
      textFinal = "${truncated.substring(0, 2)}.${truncated.substring(2)}";
    } else if (truncated.length <= 8) {
      textFinal =
          "${truncated.substring(0, 2)}.${truncated.substring(2, 5)}.${truncated.substring(5)}";
    } else if (truncated.length <= 12) {
      textFinal =
          "${truncated.substring(0, 2)}.${truncated.substring(2, 5)}.${truncated.substring(5, 8)}/${truncated.substring(8)}";
    } else {
      textFinal =
          "${truncated.substring(0, 2)}.${truncated.substring(2, 5)}.${truncated.substring(5, 8)}/${truncated.substring(8, 12)}-${truncated.substring(12)}";
    }

    return TextEditingValue(
      text: textFinal,
      selection: TextSelection.collapsed(offset: textFinal.length),
    );
  }
}
