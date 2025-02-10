import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('E, dd-MM-yyyy').format(dateTime);
  }
}