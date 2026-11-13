import 'package:flutter/foundation.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/application/get_care_shifts_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_circle_members_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_my_circle_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_shared_notes_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_date_format.dart';

class CircleViewModel extends ChangeNotifier {
  final GetMyCircleUseCase _getMyCircle;
  final GetCircleMembersUseCase _getCircleMembers;
  final GetCareShiftsUseCase _getCareShifts;
  final GetSharedNotesUseCase _getSharedNotes;
  final SessionStorage _storage;

  new({
    required this._getMyCircle,
    required this._getCircleMembers,
    required this._getCareShifts,
    required this._getSharedNotes,
    required this._storage,
  });

  static const String noLink = 'Aún no tienes un familiar vinculado.';

  bool isLoading = false;
  String? errorMessage;
  MyCircle? circle;
  List<CircleMember> members = [];
  CareShift? todayShift;
  List<SharedNote> notes = [];
  String? token;

  Future<void> load({bool refresh = false}) async {
    if (!refresh) {
      circle = null;
      members = [];
      todayShift = null;
      notes = [];
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await CircleDateFormat.ensureInitialized();
      final MyCircle? myCircle = await _getMyCircle.execute();
      if (myCircle == null) {
        circle = null;
        errorMessage = noLink;
        return;
      }
      final DateTime today = DateTime.now();
      final List<CircleMember> loadedMembers = await _getCircleMembers.execute(
        myCircle.careCircleId,
      );
      final List<CareShift> shifts = await _getCareShifts.execute(
        myCircle.careCircleId,
        today,
        today,
      );
      final List<SharedNote> loadedNotes = await _getSharedNotes.execute(
        myCircle.careCircleId,
      );
      token = await _storage.getToken();
      members = loadedMembers;
      todayShift = shifts.isEmpty ? null : shifts.first;
      notes = loadedNotes;
      circle = myCircle;
    } catch (e) {
      errorMessage = ErrorMessages.from(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String get olderAdultFirstName => circle?.olderAdultFirstName ?? '';

  String get title => 'Círculo de $olderAdultFirstName';

  String get subtitle {
    return 'Quiénes acompañan a $olderAdultFirstName y cómo se organizan.';
  }

  String get revokeLabel => 'Quitar mi vínculo con $olderAdultFirstName';

  String firstNameOf(String userId) {
    for (final CircleMember member in members) {
      if (member.userId == userId) return member.firstName;
    }
    return 'un familiar';
  }

  String? get shiftSummary {
    final CareShift? shift = todayShift;
    if (shift == null) return null;
    if (shift.isMine) return 'Hoy te toca a ti';
    final String? assigneeId = shift.assigneeId;
    if (assigneeId == null) return 'Hoy nadie se ha anotado';
    return 'Hoy acompaña ${firstNameOf(assigneeId)}';
  }

  String get notesSummary {
    if (notes.isEmpty) return 'Aún no hay notas';
    final SharedNote latest = notes.first;
    final String when = CircleDateFormat.relativeDay(
      latest.createdAt,
      DateTime.now(),
    );
    final String author = latest.isMine
        ? 'tuya'
        : 'de ${firstNameOf(latest.authorId)}';
    if (notes.length == 1) return '1 nota · $author, $when';
    final String last = latest.isMine
        ? 'la última es tuya'
        : 'la última $author';
    return '${notes.length} notas · $last, $when';
  }
}
