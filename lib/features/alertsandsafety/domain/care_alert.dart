import 'package:serenia_app/features/alertsandsafety/domain/alert_status.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_type.dart';

class CareAlert {
  final String id;
  final String olderAdultId;
  final AlertType type;
  final AlertStatus status;
  final DateTime triggeredAt;
  final String? acknowledgedBy;
  final DateTime? acknowledgedAt;
  final String? resolvedBy;
  final DateTime? resolvedAt;

  const new({
    required this.id,
    required this.olderAdultId,
    required this.type,
    required this.status,
    required this.triggeredAt,
    this.acknowledgedBy,
    this.acknowledgedAt,
    this.resolvedBy,
    this.resolvedAt,
  });
}
