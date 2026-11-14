import 'dart:io';

import 'package:intl/intl.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/session.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_already_covered_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_date_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_reassign_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_repository.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/assign_care_shift_request_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_shift_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_shifts_api.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/reassign_care_shift_request_dto.dart';

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

  @override
  Future<CareShift> assignCareShift(String careCircleId, DateTime date) async {
    try {
      final CareShiftDto dto = await _api.assignCareShift(
        careCircleId,
        AssignCareShiftRequestDto(shiftDate: _apiDate.format(date)),
      );
      final Session? session = await _storage.getSession();
      return _toCareShift(dto, session?.userId);
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.conflict) {
        throw const CareShiftAlreadyCoveredException();
      }
      if (e.statusCode == HttpStatus.unprocessableEntity) {
        throw const CareShiftDateNotAllowedException();
      }
      rethrow;
    }
  }

  @override
  Future<CareShift> reassignCareShift(
    String careCircleId,
    String careShiftId,
    String relativeId,
  ) async {
    try {
      final CareShiftDto dto = await _api.reassignCareShift(
        careCircleId,
        careShiftId,
        ReassignCareShiftRequestDto(relativeId: relativeId),
      );
      final Session? session = await _storage.getSession();
      return _toCareShift(dto, session?.userId);
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.notFound ||
          e.statusCode == HttpStatus.unprocessableEntity) {
        throw const CareShiftReassignNotAllowedException();
      }
      rethrow;
    }
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
