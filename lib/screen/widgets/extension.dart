import 'package:intl/intl.dart';

extension CurrencyParsing on double {
  String toCNY() {
    final formatter = NumberFormat('#,##0');

    return "¥${formatter.format(this)}";
  }
}
