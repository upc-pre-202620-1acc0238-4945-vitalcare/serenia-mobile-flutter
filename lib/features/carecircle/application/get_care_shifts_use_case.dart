import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_repository.dart';

class GetCareShiftsUseCase {
  final CareShiftRepository _repository;
  const new({required this._repository});

  Future<List<CareShift>> execute(
    String careCircleId,
    DateTime from,
    DateTime to,
  ) async {
    final DateTime first = DateTime(from.year, from.month, from.day);
    final DateTime last = DateTime(to.year, to.month, to.day);
    final List<CareShift> assigned = await _repository.getCareShifts(
      careCircleId,
      first,
      last,
    );
    final List<CareShift> days = [];
    for (
      DateTime day = first;
      !day.isAfter(last);
      day = DateTime(day.year, day.month, day.day + 1)
    ) {
      days.add(
        assigned.firstWhere(
          (shift) => _isSameDay(shift.date, day),
          orElse: () => CareShift(date: day),
        ),
      );
    }
    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
