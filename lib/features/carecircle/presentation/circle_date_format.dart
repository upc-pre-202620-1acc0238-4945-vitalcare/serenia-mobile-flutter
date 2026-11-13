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
}
