import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class AlertBanner extends StatelessWidget {
  final String _message;
  final bool _mayor;

  const new(this._message, {super.key, this._mayor = false});

  @override
  Widget build(BuildContext context) {
    final double fontSize = _mayor ? 18 : 16;
    final double lineHeight = _mayor ? 26 : 22;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SereniaSpacing.md),
        decoration: BoxDecoration(
          color: SereniaColors.errorBg,
          borderRadius: BorderRadius.circular(SereniaRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: SereniaColors.error,
              size: _mayor ? 28 : 24,
            ),
            Expanded(
              child: Text(
                _message,
                style: TextStyle(
                  color: SereniaColors.neutro800,
                  fontSize: fontSize,
                  height: lineHeight / fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
