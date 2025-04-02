import 'package:intl/intl.dart';

class AppDateUtils {
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

  static DateTime getDateForDay(int weekday, DateTime from) {
    final int currentDay = from.weekday;
    final int targetDay = weekday;
    final delta = currentDay > targetDay ? targetDay : (7 - targetDay);
    final daysToAdd = (7 - currentDay) + delta;
    final result = from.add(Duration(days: daysToAdd));
    return result;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }
}
