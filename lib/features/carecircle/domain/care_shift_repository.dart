import 'package:serenia_app/features/carecircle/domain/care_shift.dart';

abstract class CareShiftRepository {
  Future<List<CareShift>> getCareShifts(
    String careCircleId,
    DateTime from,
    DateTime to,
  );
  Future<CareShift> assignCareShift(String careCircleId, DateTime date);
}
