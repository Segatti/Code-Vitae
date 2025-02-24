extension StringExtension on String {
  String removeDiacritics() {
    var str = this;
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  String removeSpecialCharactersAndSpaces() {
    // Expressão regular para manter apenas letras e números
    return replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  String getInitialName() {
    if (isEmpty) return '';
    List<String> words = trim().split(' ');
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  DateTime? toDateTimeFromTime() {
    if (isEmpty) return null;
    try {
      DateTime now = DateTime.now();

      List<String> timeParts = split(':');
      if (timeParts.length != 2) return null;
      if (timeParts.first.length != 2 || timeParts.last.length != 2) {
        return null;
      }
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      if (hour >= 24 || minute >= 60) return null;

      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  bool isValidDate({bool hasDay = true}) {
    if (isEmpty) return false;
    var sDate = split("/");
    if ((sDate.length != 3 && hasDay) || (sDate.length != 2 && !hasDay)) {
      return false;
    }
    if (hasDay) {
      var day = int.tryParse(sDate[0]) ?? 0;
      var month = int.tryParse(sDate[1]) ?? 0;
      var year = int.tryParse(sDate[2]) ?? 0;

      if (day <= 0 || day > 31) return false;
      if (month <= 0 || month > 12) return false;
      if (year <= 0 || year.toString().length < 4) return false;
    } else {
      var month = int.tryParse(sDate[0]) ?? 0;
      var year = int.tryParse(sDate[1]) ?? 0;

      if (month <= 0 || month > 12) return false;
      if (year <= 0 || year.toString().length < 4) return false;
    }

    return true;
  }

  DateTime? toDate({bool hasDay = true}) {
    if (isEmpty) return null;
    var sDate = split("/");
    if ((sDate.length != 3 && hasDay) || (sDate.length != 2 && !hasDay)) {
      return null;
    }

    if (hasDay) {
      var day = int.tryParse(sDate[0]) ?? 0;
      var month = int.tryParse(sDate[1]) ?? 0;
      var year = int.tryParse(sDate[2]) ?? 0;
      var date = DateTime(year, month, day);
      return date;
    } else {
      var month = int.tryParse(sDate[0]) ?? 0;
      var year = int.tryParse(sDate[1]) ?? 0;
      var date = DateTime(year, month);
      return date;
    }
  }

  num? moneyToNumber() {
    if (isEmpty) return null;
    var data = substring(3).replaceAll(".", "").replaceAll(",", ".");
    return num.tryParse(data);
  }
}
