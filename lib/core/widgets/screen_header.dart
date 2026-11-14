import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class ScreenHeader extends StatelessWidget {
  final String _title;
  final String? _date;
  final String? _subtitle;
  final Widget? _trailing;

  const new({
    super.key,
    required this._title,
    this._date,
    this._subtitle,
    this._trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: SereniaSpacing.xs,
            children: [
              if (_date != null)
                Text(
                  _date,
                  style: const TextStyle(
                    color: SereniaColors.neutro600,
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Semantics(
                header: true,
                child: Text(
                  _title,
                  style: TextStyle(
                    color: SereniaColors.title,
                    fontSize: _date != null ? 26 : 28,
                    height: _date != null ? 32 / 26 : 34 / 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: _date != null ? -0.13 : 0,
                  ),
                ),
              ),
              if (_subtitle != null)
                Text(
                  _subtitle,
                  style: const TextStyle(
                    color: SereniaColors.neutro700,
                    fontSize: 16,
                    height: 24 / 16,
                  ),
                ),
            ],
          ),
        ),
        ?_trailing,
      ],
    );
  }
}
