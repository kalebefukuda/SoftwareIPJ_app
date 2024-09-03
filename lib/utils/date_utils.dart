import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }
}