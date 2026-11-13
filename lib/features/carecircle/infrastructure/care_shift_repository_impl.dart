import 'package:intl/intl.dart';
import 'package:serenia_app/core/session.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_repository.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_shift_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_shifts_api.dart';

class CareShiftRepositoryImpl implements CareShiftRepository {
  final CareShiftsApi _api;
  final SessionStorage _storage;
  const new({required this._api, required this._storage});

  static final DateFormat _apiDate = DateFormat('yyyy-MM-dd');

  @override
  Future<List<CareShift>> getCareShifts(
    String careCircleId,
    DateTime from,
    DateTime to,
  ) async {
    final List<CareShiftDto> dtos = await _api.getCareShifts(
      careCircleId,
      _apiDate.format(from),
      _apiDate.format(to),
    );
    final Session? session = await _storage.getSession();
    return dtos.map((dto) => _toCareShift(dto, session?.userId)).toList();
  }

  CareShift _toCareShift(CareShiftDto dto, String? myUserId) {
    return CareShift(
      id: dto.id,
      date: DateTime.parse(dto.shiftDate),
      assigneeId: dto.relativeId,
      isMine: dto.relativeId == myUserId,
    );
  }
}
