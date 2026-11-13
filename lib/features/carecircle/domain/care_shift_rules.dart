class CareShiftRules {
  static const int weeksAhead = 4;

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime lastAssignableDay(DateTime today) {
    final DateTime day = dateOnly(today);
    return DateTime(
      day.year,
      day.month,
      day.day + weeksAhead * DateTime.daysPerWeek,
    );
  }

  static bool isPast(DateTime date, DateTime today) {
    return dateOnly(date).isBefore(dateOnly(today));
  }

  static bool canAssign(DateTime date, DateTime today) {
    return !isPast(date, today) &&
        !dateOnly(date).isAfter(lastAssignableDay(today));
  }
}
