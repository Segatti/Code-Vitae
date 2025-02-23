import 'package:flutter/services.dart';

class FormatterHelper {
  static String getTextFormatted(String? value, TextInputFormatter format){
    return format
        .formatEditUpdate(
          TextEditingValue(text: value ?? ""),
          TextEditingValue(text: value ?? ""),
        )
        .text;
  }
}