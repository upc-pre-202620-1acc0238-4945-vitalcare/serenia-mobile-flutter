import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_reassign_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_repository.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_rules.dart';

class ReassignCareShiftUseCase {
  final CareShiftRepository _repository;
  const new({required this._repository});

  Future<CareShift> execute(
    String careCircleId,
    CareShift shift,
    String relativeId,
  ) {
    final String? shiftId = shift.id;
    final bool allowed =
        shiftId != null &&
        shift.isMine &&
        !CareShiftRules.isPast(shift.date, DateTime.now()) &&
        shift.assigneeId != relativeId;
    if (!allowed) {
      throw const CareShiftReassignNotAllowedException();
    }
    return _repository.reassignCareShift(careCircleId, shiftId, relativeId);
  }
}
