import 'package:flutter/foundation.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/carecircle/application/assign_care_shift_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_care_shifts_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_already_covered_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_date_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_rules.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_date_format.dart';

class CareShiftsViewModel extends ChangeNotifier {
  final GetCareShiftsUseCase _getCareShifts;
  final AssignCareShiftUseCase _assignCareShift;

  new({required this._getCareShifts, required this._assignCareShift});

  static const String dateNotAllowed =
      'Solo puedes anotarte desde hoy y hasta 4 semanas adelante.';

  bool isLoading = false;
  bool isAssigning = false;
  String? errorMessage;
  String? assignError;
  DateTime? conflictDate;

  String careCircleId = '';
  String olderAdultFirstName = '';
  List<CircleMember> members = [];
  late DateTime today;
  late DateTime weekStart;
  List<CareShift> days = [];
  int selectedIndex = 0;

  DateTime get weekEnd {
    return DateTime(weekStart.year, weekStart.month, weekStart.day + 6);
  }

  CareShift? get selectedDay {
    return selectedIndex < days.length ? days[selectedIndex] : null;
  }

  bool get canGoNext {
    final DateTime nextStart = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + DateTime.daysPerWeek,
    );
    return !nextStart.isAfter(CareShiftRules.lastAssignableDay(today));
  }

  bool canAssign(CareShift day) {
    return day.isFree && CareShiftRules.canAssign(day.date, today);
  }

  bool isConflict(CareShift day) {
    final DateTime? date = conflictDate;
    return date != null && date == day.date && !day.isFree && !day.isMine;
  }

  String firstNameOf(String userId) {
    for (final CircleMember member in members) {
      if (member.userId == userId) return member.firstName;
    }
    return 'otro familiar';
  }

  List<String> get otherFirstNames {
    return [
      for (final CircleMember member in members)
        if (!member.isMe) member.firstName,
    ];
  }

  DateTime _mondayOf(DateTime date) {
    return DateTime(date.year, date.month, date.day - (date.weekday - 1));
  }

  Future<void> open({
    required String careCircleId,
    required String olderAdultFirstName,
    required List<CircleMember> members,
  }) async {
    this.careCircleId = careCircleId;
    this.olderAdultFirstName = olderAdultFirstName;
    this.members = members;
    today = CareShiftRules.dateOnly(DateTime.now());
    weekStart = _mondayOf(today);
    selectedIndex = today.weekday - 1;
    days = [];
    await CircleDateFormat.ensureInitialized();
    await loadWeek();
  }

  Future<void> loadWeek() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      days = await _getCareShifts.execute(careCircleId, weekStart, weekEnd);
    } catch (e) {
      errorMessage = ErrorMessages.from(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectDay(int index) {
    selectedIndex = index;
    assignError = null;
    conflictDate = null;
    notifyListeners();
  }

  Future<void> _moveWeek(int weeks, int selected) async {
    weekStart = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + weeks * DateTime.daysPerWeek,
    );
    selectedIndex = selected;
    assignError = null;
    conflictDate = null;
    await loadWeek();
  }

  Future<void> previousWeek() => _moveWeek(-1, 0);

  Future<void> nextWeek() async {
    if (canGoNext) await _moveWeek(1, 0);
  }

  Future<void> assignSelected() async {
    final CareShift? day = selectedDay;
    if (day == null || isAssigning || !canAssign(day)) return;
    isAssigning = true;
    assignError = null;
    conflictDate = null;
    notifyListeners();
    try {
      await _assignCareShift.execute(careCircleId, day.date);
      await loadWeek();
    } on CareShiftAlreadyCoveredException {
      conflictDate = day.date;
      await loadWeek();
    } on CareShiftDateNotAllowedException {
      assignError = dateNotAllowed;
    } catch (e) {
      assignError = ErrorMessages.from(e);
    } finally {
      isAssigning = false;
      notifyListeners();
    }
  }

  Future<void> showNextFreeDay() async {
    conflictDate = null;
    while (true) {
      for (int index = 0; index < days.length; index++) {
        final CareShift day = days[index];
        if (canAssign(day) && day.date.isAfter(today.subtract(_oneDay))) {
          selectDay(index);
          return;
        }
      }
      if (!canGoNext) {
        notifyListeners();
        return;
      }
      await _moveWeek(1, 0);
      if (errorMessage != null) return;
    }
  }

  static const Duration _oneDay = Duration(days: 1);
}
