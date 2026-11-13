import 'dart:io';

import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_state_conflict_exception.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_status.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_type.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alerts_repository.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/remote/alert_dto.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/remote/alerts_api.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/remote/resolve_alert_request_dto.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsApi _api;
  const new({required this._api});

  @override
  Future<List<CareAlert>> getAlerts(String olderAdultId) async {
    final List<AlertDto> dtos = await _api.getAlerts(olderAdultId);
    return dtos.map(_toCareAlert).toList();
  }

  @override
  Future<CareAlert> acknowledge(CareAlert alert) async {
    try {
      final AlertDto dto = await _api.acknowledge(
        _typePath(alert.type),
        alert.id,
      );
      return _toCareAlert(dto);
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.conflict) {
        throw const AlertStateConflictException();
      }
      rethrow;
    }
  }

  @override
  Future<CareAlert> resolve(CareAlert alert) async {
    try {
      final AlertDto dto = await _api.resolve(
        _typePath(alert.type),
        alert.id,
        const ResolveAlertRequestDto(),
      );
      return _toCareAlert(dto);
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.conflict) {
        throw const AlertStateConflictException();
      }
      rethrow;
    }
  }

  String _typePath(AlertType type) {
    return switch (type) {
      AlertType.emergency => 'emergency-alerts',
      AlertType.inactivity => 'inactivity-alerts',
    };
  }

  CareAlert _toCareAlert(AlertDto dto) {
    return CareAlert(
      id: dto.id,
      olderAdultId: dto.olderAdultId,
      type: AlertType.fromName(dto.type),
      status: AlertStatus.fromName(dto.status),
      triggeredAt: DateTime.parse(dto.triggeredAt).toLocal(),
      acknowledgedBy: dto.acknowledgedBy,
      acknowledgedAt: _parseDate(dto.acknowledgedAt),
      resolvedBy: dto.resolvedBy,
      resolvedAt: _parseDate(dto.resolvedAt),
    );
  }

  DateTime? _parseDate(String? value) {
    return value == null ? null : DateTime.parse(value).toLocal();
  }
}
