import 'package:intl/intl.dart';

class ApPDateUtils {
  static getFormatedDateForList(DateTime startDate, {DateTime? endDate}) {
    String dateString = formatDate(startDate);
    if (endDate != null) {
      final endString = formatDate(endDate);
      dateString = [dateString, endString].join(' - ');
    }
    return dateString;
  }

  static formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(date);
  }
}
