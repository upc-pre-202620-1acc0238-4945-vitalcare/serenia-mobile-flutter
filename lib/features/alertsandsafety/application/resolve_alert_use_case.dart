import 'package:serenia_app/features/alertsandsafety/domain/alerts_repository.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';

class ResolveAlertUseCase {
  final AlertsRepository _repository;
  const new({required this._repository});

  Future<CareAlert> execute(CareAlert alert) {
    return _repository.resolve(alert);
  }
}
