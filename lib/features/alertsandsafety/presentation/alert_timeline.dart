import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_date_format.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_presentation.dart';

class AlertTimeline extends StatelessWidget {
  final List<TimelineStep> _steps;

  const new({super.key, required this._steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _steps.length; i++)
          _TimelineRow(step: _steps[i], isLast: i == _steps.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TimelineStep _step;
  final bool _isLast;

  const new({required this._step, required this._isLast});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${_step.title}, ${AlertDateFormat.time(_step.at)}',
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _step.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!_isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: SereniaColors.neutro200,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: _isLast ? 0 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _step.title,
                      style: const TextStyle(
                        color: SereniaColors.text,
                        fontSize: 16,
                        height: 22 / 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AlertDateFormat.time(_step.at),
                      style: const TextStyle(
                        color: SereniaColors.neutro600,
                        fontSize: 15,
                        height: 20 / 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
