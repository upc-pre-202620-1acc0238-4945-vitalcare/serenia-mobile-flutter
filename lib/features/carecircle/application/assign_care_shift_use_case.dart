import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_date_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_repository.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_rules.dart';

class AssignCareShiftUseCase {
  final CareShiftRepository _repository;
  const new({required this._repository});

  Future<CareShift> execute(String careCircleId, DateTime date) {
    if (!CareShiftRules.canAssign(date, DateTime.now())) {
      throw const CareShiftDateNotAllowedException();
    }
    return _repository.assignCareShift(
      careCircleId,
      CareShiftRules.dateOnly(date),
    );
  }
}
