import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';
import 'package:serenia_app/core/widgets/status_chip.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_date_format.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_people.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_presentation.dart';

class AlertCard extends StatelessWidget {
  final CareAlert _alert;
  final AlertPeople _people;
  final VoidCallback _onTap;

  const new({
    super.key,
    required this._alert,
    required this._people,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String title = _alert.title(_people);
    final String when = AlertDateFormat.summary(_alert.triggeredAt, now);
    final String? owner = _alert.ownerLine(_people);
    final bool urgent = _alert.isEmergency && _alert.status.isPending;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label:
          '${_alert.typeLabel}, ${_alert.statusLabel}. $title. $when.'
          '${owner == null ? '' : ' $owner.'}',
      onTap: _onTap,
      child: SereniaCard(
        onTap: _onTap,
        borderColor: urgent ? SereniaColors.error : null,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      StatusChip(
                        label: _alert.typeLabel,
                        tone: _alert.typeTone,
                      ),
                      StatusChip(
                        label: _alert.statusLabel,
                        tone: _alert.statusTone,
                      ),
                    ],
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: SereniaColors.text,
                      fontSize: 17,
                      height: 24 / 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    when,
                    style: const TextStyle(
                      color: SereniaColors.neutro700,
                      fontSize: 15,
                      height: 20 / 15,
                    ),
                  ),
                  if (owner != null)
                    Text(
                      owner,
                      style: const TextStyle(
                        color: SereniaColors.teal800,
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SereniaColors.primary,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
