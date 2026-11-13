import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CircleDateFormat {
  static const String locale = 'es';

  static Future<void> ensureInitialized() {
    return initializeDateFormatting(locale);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final DateTime start = DateTime.utc(from.year, from.month, from.day);
    final DateTime end = DateTime.utc(to.year, to.month, to.day);
    return end.difference(start).inDays;
  }

  static String relativeDay(DateTime at, DateTime now) {
    final int days = daysBetween(at, now);
    if (days <= 0) return 'hoy';
    if (days == 1) return 'ayer';
    if (days < DateTime.daysPerWeek) return 'hace $days días';
    return 'el ${DateFormat("d 'de' MMMM", locale).format(at)}';
  }

  static String capitalize(String text) {
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

  static String weekdayShort(DateTime date) {
    return capitalize(DateFormat.E(locale).format(date).replaceAll('.', ''));
  }

  static String weekdayLong(DateTime date) {
    return DateFormat.EEEE(locale).format(date);
  }

  static String dayLabel(DateTime date, DateTime today) {
    final String day = '${weekdayLong(date)} ${date.day}';
    return daysBetween(today, date) == 0 ? 'Hoy, $day' : capitalize(day);
  }

  static String weekRange(DateTime start, DateTime end) {
    final DateFormat dayMonth = DateFormat("d 'de' MMMM", locale);
    if (start.month == end.month) {
      return '${start.day} – ${dayMonth.format(end)}';
    }
    return '${dayMonth.format(start)} – ${dayMonth.format(end)}';
  }
}
