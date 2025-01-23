import 'package:intl/intl.dart';

class CustomDateUtils {
  /// Formats a date string into the desired format.
  ///
  /// [date] is the date string in 'yyyy-MM-dd' format.
  /// [format] is the desired date format, e.g., 'MMM d, yyyy'.
  static String formatDate(String date, String format) {
    final parsedDate = DateTime.parse(date);
    final formatter = DateFormat(format);
    return formatter.format(parsedDate);
  }
}
