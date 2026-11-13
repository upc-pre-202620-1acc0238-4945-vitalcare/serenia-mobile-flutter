import 'package:serenia_app/features/alertsandsafety/domain/alerts_repository.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';

class GetAlertsUseCase {
  final AlertsRepository _repository;
  const new({required this._repository});

  Future<List<CareAlert>> execute(String olderAdultId) {
    return _repository.getAlerts(olderAdultId);
  }
}
