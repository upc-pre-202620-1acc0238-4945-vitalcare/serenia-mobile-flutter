import 'package:flutter/painting.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/widgets/status_chip.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_status.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alert_type.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_date_format.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_people.dart';

class TimelineStep {
  final String title;
  final DateTime at;
  final Color color;

  const new({required this.title, required this.at, required this.color});
}

extension AlertPresentation on CareAlert {
  bool get isEmergency => type == AlertType.emergency;

  String title(AlertPeople people) {
    return isEmergency
        ? '${people.olderAdultFirstName} pidió ayuda'
        : 'No respondió su pregunta del día';
  }

  String get typeLabel => isEmergency ? 'Pidió ayuda' : 'Sin responder';

  ChipTone get typeTone => isEmergency ? ChipTone.help : ChipTone.noAnswer;

  String get statusLabel {
    if (status.isResolved) return 'Resuelta';
    if (status.isAcknowledged) return 'Atendiendo';
    return 'Pendiente';
  }

  ChipTone get statusTone {
    if (status.isResolved) return ChipTone.done;
    if (status.isAcknowledged) return ChipTone.attending;
    return ChipTone.pending;
  }

  String _who(String? userId, AlertPeople people) {
    return people.firstNameOf(userId) ?? 'otro familiar';
  }

  String? ownerLine(AlertPeople people) {
    if (status.isResolved) {
      if (resolvedBy == null) return null;
      return people.isMe(resolvedBy)
          ? 'Resuelta por ti'
          : 'Resuelta por ${_who(resolvedBy, people)}';
    }
    if (status.isAcknowledged) {
      return people.isMe(acknowledgedBy)
          ? 'La estás atendiendo tú'
          : '${_capitalize(_who(acknowledgedBy, people))} la está atendiendo';
    }
    return null;
  }

  String description(DateTime now) {
    final String when = AlertDateFormat.full(triggeredAt, now);
    return isEmergency
        ? '$when Mantuvo presionado su botón de ayuda.'
        : '$when Pasó una hora desde su pregunta sin respuesta.';
  }

  List<TimelineStep> timeline(AlertPeople people) {
    final List<TimelineStep> steps = [
      TimelineStep(
        title: isEmergency
            ? '${people.olderAdultFirstName} pidió ayuda'
            : 'Pasó una hora sin respuesta',
        at: triggeredAt,
        color: isEmergency ? SereniaColors.error : SereniaColors.warning,
      ),
    ];
    final bool notified =
        status == AlertStatus.dispatched ||
        status.isAcknowledged ||
        status.isResolved;
    if (isEmergency && notified) {
      steps.add(
        TimelineStep(
          title: 'Avisamos a tu familia',
          at: triggeredAt,
          color: SereniaColors.neutro400,
        ),
      );
    }
    if (acknowledgedAt != null) {
      final bool me = people.isMe(acknowledgedBy);
      final String name = _who(acknowledgedBy, people);
      final String title = status.isResolved
          ? (me ? 'Tú te encargaste' : '${_capitalize(name)} se encargó')
          : (me
                ? 'Tú la estás atendiendo'
                : '${_capitalize(name)} la está atendiendo');
      steps.add(
        TimelineStep(
          title: title,
          at: acknowledgedAt!,
          color: SereniaColors.teal700,
        ),
      );
    }
    if (resolvedAt != null) {
      steps.add(
        TimelineStep(
          title: ownerLine(people) ?? 'Resuelta',
          at: resolvedAt!,
          color: SereniaColors.verde600,
        ),
      );
    }
    return steps;
  }

  static String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
