import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isNotEmpty) {
      double value = double.parse(digitsOnly);

      final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

      String newText = formatter.format(value / 100);

      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else {
      return newValue.copyWith(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }
  }
}
