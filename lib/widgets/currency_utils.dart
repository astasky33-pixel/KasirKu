import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(num value) {
    return _formatter.format(value);
  }

  static String formatDisplay(String value) {
    if (value == '0' || value == 'Error') return value;
    
    // Split by operators to format numbers only
    final parts = value.split(' ');
    for (int i = 0; i < parts.length; i++) {
      double? numValue = double.tryParse(parts[i]);
      if (numValue != null) {
        parts[i] = _formatter.format(numValue);
      } else if (parts[i] == '*') {
        parts[i] = 'x';
      }
    }
    return parts.join(' ');
  }
}
