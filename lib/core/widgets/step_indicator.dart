import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class StepIndicator extends StatelessWidget {
  final int _current;
  final int _total;

  const new({super.key, required this._current, this._total = 3});

  @override
  Widget build(BuildContext context) {
    final String label = 'Paso $_current de $_total';
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 6,
            children: [
              for (int step = 1; step <= _total; step++)
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: step <= _current
                          ? SereniaColors.primary
                          : SereniaColors.neutro300,
                      borderRadius: BorderRadius.circular(SereniaRadius.pill),
                    ),
                  ),
                ),
            ],
          ),
          Text(
            label,
            style: const TextStyle(
              color: SereniaColors.neutro700,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
