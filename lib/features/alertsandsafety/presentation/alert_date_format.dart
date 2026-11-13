class AlertDateFormat {
  static const List<String> _months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static const List<String> _weekdays = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];

  static String time(DateTime date) {
    final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String meridiem = date.hour < 12 ? 'a. m.' : 'p. m.';
    return '$hour:$minute $meridiem';
  }

  static String _day(DateTime date) {
    final String weekday = _weekdays[date.weekday - 1];
    return '$weekday ${date.day} de ${_months[date.month - 1]}';
  }

  static int _daysAgo(DateTime date, DateTime now) {
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime day = DateTime(date.year, date.month, date.day);
    return today.difference(day).inDays;
  }

  static String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static String summary(DateTime date, DateTime now) {
    final int daysAgo = _daysAgo(date, now);
    if (daysAgo == 0) return 'Hoy, ${time(date)}';
    if (daysAgo == 1) return 'Ayer, ${time(date)}';
    return _capitalize(_day(date));
  }

  static String full(DateTime date, DateTime now) {
    final int daysAgo = _daysAgo(date, now);
    final String atTime = 'a las ${time(date)}';
    if (daysAgo == 0) return 'Hoy, ${_day(date)}, $atTime';
    if (daysAgo == 1) return 'Ayer, ${_day(date)}, $atTime';
    return '${_capitalize(_day(date))}, $atTime';
  }
}
