import 'package:intl/intl.dart';

extension NumberExt on num {
  String toMoney() {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  return currencyFormat.format(this);
}
}
