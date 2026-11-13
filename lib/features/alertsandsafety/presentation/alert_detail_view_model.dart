import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/alertsandsafety/application/acknowledge_alert_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/application/resolve_alert_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_state_conflict_exception.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';

enum AlertDetailResult { resolved, outdated }

class AlertDetailState {
  final CareAlert alert;
  final bool acting;
  final String? error;
  final AlertDetailResult? result;

  const new({
    required this.alert,
    this.acting = false,
    this.error,
    this.result,
  });

  AlertDetailState copyWith({
    CareAlert? alert,
    bool? acting,
    String? Function()? error,
    AlertDetailResult? result,
  }) {
    return AlertDetailState(
      alert: alert ?? this.alert,
      acting: acting ?? this.acting,
      error: error == null ? this.error : error(),
      result: result ?? this.result,
    );
  }
}

class AlertDetailViewModel extends Cubit<AlertDetailState> {
  final AcknowledgeAlertUseCase _acknowledge;
  final ResolveAlertUseCase _resolve;

  new({
    required this._acknowledge,
    required this._resolve,
    required CareAlert alert,
  }) : super(AlertDetailState(alert: alert));

  Future<void> acknowledge() async {
    if (state.acting) return;
    emit(state.copyWith(acting: true, error: () => null));
    try {
      final CareAlert updated = await _acknowledge.execute(state.alert);
      emit(state.copyWith(alert: updated, acting: false));
    } on AlertStateConflictException {
      emit(state.copyWith(acting: false, result: AlertDetailResult.outdated));
    } catch (e) {
      emit(state.copyWith(acting: false, error: () => ErrorMessages.from(e)));
    }
  }

  Future<void> resolve() async {
    if (state.acting) return;
    emit(state.copyWith(acting: true, error: () => null));
    try {
      final CareAlert updated = await _resolve.execute(state.alert);
      emit(
        state.copyWith(
          alert: updated,
          acting: false,
          result: AlertDetailResult.resolved,
        ),
      );
    } on AlertStateConflictException {
      emit(state.copyWith(acting: false, result: AlertDetailResult.outdated));
    } catch (e) {
      emit(state.copyWith(acting: false, error: () => ErrorMessages.from(e)));
    }
  }
}
