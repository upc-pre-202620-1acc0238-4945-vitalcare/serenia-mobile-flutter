import 'package:flutter/foundation.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/carecircle/application/reassign_care_shift_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_reassign_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';

class ReassignCareShiftViewModel extends ChangeNotifier {
  final ReassignCareShiftUseCase _reassignCareShift;

  new({required this._reassignCareShift});

  static const String notAllowed =
      'Este turno ya no se puede pasar. Revisa la semana de nuevo.';

  bool isLoading = false;
  String? errorMessage;
  String careCircleId = '';
  CareShift? shift;
  List<CircleMember> candidates = [];
  String? selectedUserId;
  String? token;

  void open({
    required String careCircleId,
    required CareShift shift,
    required List<CircleMember> members,
    String? token,
  }) {
    this.token = token;
    this.careCircleId = careCircleId;
    this.shift = shift;
    candidates = [
      for (final CircleMember member in members)
        if (!member.isMe) member,
    ];
    selectedUserId = candidates.length == 1 ? candidates.first.userId : null;
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  CircleMember? get selected {
    for (final CircleMember member in candidates) {
      if (member.userId == selectedUserId) return member;
    }
    return null;
  }

  void select(String userId) {
    selectedUserId = userId;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> reassign() async {
    final CareShift? current = shift;
    final String? userId = selectedUserId;
    if (current == null || userId == null || isLoading) return false;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _reassignCareShift.execute(careCircleId, current, userId);
      return true;
    } on CareShiftReassignNotAllowedException {
      errorMessage = notAllowed;
      return false;
    } catch (e) {
      errorMessage = ErrorMessages.from(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
