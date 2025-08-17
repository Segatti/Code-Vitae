import 'package:intl/intl.dart';

extension NumberExt on num {
  String toMoney({bool useFree = true, bool useSymbol = true}) {
    // Normalizando até a 2 casa decimal
    final normalized = (this * 100).truncate() / 100;

    if (normalized == 0 && useFree) return "Grátis";
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: (useSymbol) ? 'R\$' : '',
    );
    return currencyFormat.format(this).trim();
  }

  String toNumberBr() {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
    );
    return currencyFormat.format(this).trim();
  }

  String toPercentage() {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
    );
    return currencyFormat.format(this).trim().replaceFirst(",00", "");
  }
}
