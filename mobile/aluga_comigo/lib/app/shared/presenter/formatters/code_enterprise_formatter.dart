import 'package:flutter/services.dart';

class CodeEnterpriseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Permitir apenas letras (A-Z, a-z) e números (0-9), sem espaços
    final filteredText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}
