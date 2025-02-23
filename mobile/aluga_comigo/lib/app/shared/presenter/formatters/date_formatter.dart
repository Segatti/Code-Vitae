import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remover caracteres não numéricos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limitar a quantidade de caracteres a 8 (ddMMyyyy)
    final truncated = digitsOnly.substring(0, digitsOnly.length.clamp(0, 8));

    var textFinal = "";
    if (truncated.length <= 2) {
      textFinal = truncated;
    } else if (truncated.length <= 4) {
      textFinal = "${truncated.substring(0, 2)}/${truncated.substring(2)}";
    } else {
      textFinal =
          "${truncated.substring(0, 2)}/${truncated.substring(2, 4)}/${truncated.substring(4)}";
    }

    return TextEditingValue(
      text: textFinal,
      selection: TextSelection.collapsed(offset: textFinal.length),
    );
  }
}
