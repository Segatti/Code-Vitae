import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

extension StringExtension on String {
  String removeDiacritics() {
    String str = this;
    final String withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    final String withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  String limit(int limit) {
    if (length > limit) {
      return '${substring(0, limit - 3)}...';
    } else {
      return this;
    }
  }

  String removeSpecialCharactersAndSpaces() {
    // Expressão regular para manter apenas letras e números
    return replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  String toFormat(TextInputFormatter formatter) {
    return formatter
        .formatEditUpdate(
          TextEditingValue(text: this),
          TextEditingValue(text: this),
        )
        .text;
  }

  String getInitialName() {
    if (trim().isEmpty) return '';
    final List<String> words = trim().split(' ');
    words.removeWhere((String item) => item.trim().isEmpty);
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  DateTime? toDateTimeFromTime() {
    if (isEmpty) return null;
    try {
      final DateTime now = DateTime.now();

      final List<String> timeParts = split(':');
      if (timeParts.length != 2) return null;
      if (timeParts.first.length != 2 || timeParts.last.length != 2) {
        return null;
      }
      final int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      if (hour >= 24 || minute >= 60) return null;

      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  bool isValidDate({bool hasDay = true}) {
    if (isEmpty) return false;
    final List<String> sDate = split('/');
    if ((sDate.length != 3 && hasDay) || (sDate.length != 2 && !hasDay)) {
      return false;
    }
    if (hasDay) {
      final int day = int.tryParse(sDate[0]) ?? 0;
      final int month = int.tryParse(sDate[1]) ?? 0;
      final int year = int.tryParse(sDate[2]) ?? 0;

      if (day <= 0 || day > 31) return false;
      if (month <= 0 || month > 12) return false;
      if (year <= 0 || year.toString().length < 4) return false;
    } else {
      final int month = int.tryParse(sDate[0]) ?? 0;
      final int year = int.tryParse(sDate[1]) ?? 0;

      if (month <= 0 || month > 12) return false;
      if (year <= 0 || year.toString().length < 4) return false;
    }

    return true;
  }

  DateTime? toDate({bool hasDay = true}) {
    if (isEmpty) return null;
    final List<String> sDate = split('/');
    if ((sDate.length != 3 && hasDay) || (sDate.length != 2 && !hasDay)) {
      return null;
    }

    if (hasDay) {
      final int day = int.tryParse(sDate[0]) ?? 0;
      final int month = int.tryParse(sDate[1]) ?? 0;
      final int year = int.tryParse(sDate[2]) ?? 0;
      final DateTime date = DateTime(year, month, day);
      return date;
    } else {
      final int month = int.tryParse(sDate[0]) ?? 0;
      final int year = int.tryParse(sDate[1]) ?? 0;
      final DateTime date = DateTime(year, month);
      return date;
    }
  }

  num? moneyToNumber() {
    if (isEmpty) return null;
    final String data = substring(3).replaceAll('.', '').replaceAll(',', '.');
    return num.tryParse(data);
  }

  String capitalizeSafe() {
    if (trim().isEmpty) {
      return '';
    } else {
      final List<String> words = split(' ');
      words.removeWhere((String item) => item.trim().isEmpty);
      final String text = words.join(' ');
      return text.trim().capitalize;
    }
  }

  String capitalizeFirstSafe() {
    if (trim().isEmpty) {
      return '';
    } else {
      final List<String> words = split(' ');
      words.removeWhere((String item) => item.trim().isEmpty);
      final String text = words.join(' ');
      return text.trim().capitalizeFirst;
    }
  }
}

extension StringColor on String {
  Color get colorFromHex {
    return Colors.transparent.fromHex(this);
  }
}

extension StringEmailMask on String {
  String maskEmail() {
    if (isEmpty) return '';

    final List<String> parts = split('@');
    if (parts.length != 2) return this;

    final String username = parts[0];
    final String domain = parts[1];

    if (username.length <= 2) return this;

    final String maskedUsername =
        '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}';
    return '$maskedUsername@$domain';
  }
}
