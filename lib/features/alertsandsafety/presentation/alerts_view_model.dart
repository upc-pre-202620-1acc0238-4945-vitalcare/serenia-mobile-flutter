import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/alertsandsafety/application/get_alerts_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_people.dart';
import 'package:serenia_app/features/carecircle/application/get_circle_members_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_my_circle_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';
import 'package:serenia_app/features/iam/application/get_user_use_case.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class AlertsState {
  final bool loading;
  final String? loadError;
  final List<CareAlert> alerts;
  final AlertPeople? people;
  final String? message;

  const new({
    this.loading = true,
    this.loadError,
    this.alerts = const [],
    this.people,
    this.message,
  });

  List<CareAlert> get open {
    return alerts.where((alert) => alert.status.isOpen).toList();
  }

  int get openCount => open.length;

  List<CareAlert> get previous {
    return alerts.where((alert) => alert.status.isResolved).toList();
  }

  AlertsState copyWith({
    bool? loading,
    String? Function()? loadError,
    List<CareAlert>? alerts,
    AlertPeople? people,
    String? Function()? message,
  }) {
    return AlertsState(
      loading: loading ?? this.loading,
      loadError: loadError == null ? this.loadError : loadError(),
      alerts: alerts ?? this.alerts,
      people: people ?? this.people,
      message: message == null ? this.message : message(),
    );
  }
}

class AlertsViewModel extends Cubit<AlertsState> {
  final GetMyCircleUseCase _getMyCircle;
  final GetAlertsUseCase _getAlerts;
  final GetUserUseCase _getUser;
  final GetCircleMembersUseCase _getCircleMembers;

  new({
    required this._getMyCircle,
    required this._getAlerts,
    required this._getUser,
    required this._getCircleMembers,
  }) : super(const AlertsState());

  static const String noLink = 'Aún no tienes un familiar vinculado.';

  final Map<String, String> _firstNames = {};

  Future<void> load() async {
    if (state.people == null) {
      emit(state.copyWith(loading: true, loadError: () => null));
    }
    try {
      final MyCircle? circle = await _getMyCircle.execute();
      if (circle == null) {
        emit(state.copyWith(loading: false, loadError: () => noLink));
        return;
      }
      final Future<List<CircleMember>> loadingMembers = _loadMembers(
        circle.careCircleId,
      );
      final List<CareAlert> alerts = await _getAlerts.execute(
        circle.olderAdult.id,
      );
      final List<CircleMember> members = await loadingMembers;
      for (final CircleMember member in members) {
        _firstNames[member.userId] = member.firstName;
      }
      await _loadFirstNames(alerts, circle.myUserId);
      emit(
        state.copyWith(
          loading: false,
          loadError: () => null,
          alerts: alerts,
          people: AlertPeople(
            myUserId: circle.myUserId,
            olderAdultFirstName: circle.olderAdultFirstName,
            olderAdultPhoneNumber: circle.olderAdult.phoneNumber,
            familyFirstNames: [for (final m in members) m.firstName],
            otherFamilyFirstNames: [
              for (final m in members)
                if (!m.isMe) m.firstName,
            ],
            firstNames: Map.of(_firstNames),
          ),
        ),
      );
    } catch (e) {
      if (state.people == null) {
        emit(
          state.copyWith(
            loading: false,
            loadError: () => ErrorMessages.from(e),
          ),
        );
      } else {
        emit(state.copyWith(message: () => ErrorMessages.from(e)));
      }
    }
  }

  Future<List<CircleMember>> _loadMembers(String careCircleId) async {
    try {
      return await _getCircleMembers.execute(careCircleId);
    } catch (_) {
      return const [];
    }
  }

  Future<void> _loadFirstNames(List<CareAlert> alerts, String myUserId) async {
    final Set<String> userIds = {
      for (final CareAlert alert in alerts) ...[
        ?alert.acknowledgedBy,
        ?alert.resolvedBy,
      ],
    }..removeWhere((id) => id == myUserId || _firstNames.containsKey(id));

    await Future.wait(
      userIds.map((userId) async {
        try {
          final User user = await _getUser.execute(userId);
          _firstNames[userId] = user.fullName
              .trim()
              .split(RegExp(r'\s+'))
              .first;
        } catch (_) {}
      }),
    );
  }

  void showMessage(String message) {
    emit(state.copyWith(message: () => message));
  }

  void clearMessage() {
    emit(state.copyWith(message: () => null));
  }
}
