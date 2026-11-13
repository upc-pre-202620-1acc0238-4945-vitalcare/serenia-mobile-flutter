import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';

abstract class AlertsRepository {
  Future<List<CareAlert>> getAlerts(String olderAdultId);
  Future<CareAlert> acknowledge(CareAlert alert);
  Future<CareAlert> resolve(CareAlert alert);
}
