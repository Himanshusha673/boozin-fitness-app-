import 'package:intl/intl.dart';

class AppUtils {
  static String formatWithComma(num value) {
    return NumberFormat.decimalPattern('en_IN').format(value);
  }
}
