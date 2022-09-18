import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int digits) {
    NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id', symbol: 'Rp ', decimalDigits: digits);

    return currencyFormatter.format(number);
  }
}
