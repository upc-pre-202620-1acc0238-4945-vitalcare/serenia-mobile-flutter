import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';

class DayShiftCard extends StatelessWidget {
  final String _label;
  final String _title;
  final String? _body;
  final List<Widget> _actions;
  final String? _error;

  const new({
    super.key,
    required this._label,
    required this._title,
    this._body,
    this._actions = const [],
    this._error,
  });

  @override
  Widget build(BuildContext context) {
    final String? error = _error;
    final String? body = _body;
    return Container(
      padding: const EdgeInsets.all(SereniaSpacing.md),
      decoration: BoxDecoration(
        color: error == null ? SereniaColors.surface : SereniaColors.errorBg,
        borderRadius: BorderRadius.circular(SereniaRadius.lg),
        boxShadow: SereniaShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SereniaSpacing.tight,
        children: [
          Text(
            _label.toUpperCase(),
            style: SereniaTypography.overline.copyWith(
              color: SereniaColors.neutro700,
            ),
          ),
          Semantics(
            header: true,
            child: Text(
              _title,
              style: SereniaTypography.dayTitle.copyWith(
                color: SereniaColors.text,
              ),
            ),
          ),
          if (error != null)
            Semantics(
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: SereniaSpacing.sm,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: SereniaSpacing.xxs),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: SereniaColors.error,
                      size: SereniaSizes.inlineIcon,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      error,
                      style: SereniaTypography.cardBodyStrong.copyWith(
                        color: SereniaColors.neutro900,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (body != null)
            Text(
              body,
              style: SereniaTypography.cardBody.copyWith(
                color: SereniaColors.neutro700,
              ),
            ),
          ..._actions,
        ],
      ),
    );
  }
}
