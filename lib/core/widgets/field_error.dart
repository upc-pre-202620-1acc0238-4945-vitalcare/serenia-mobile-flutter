import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class FieldError extends StatelessWidget {
  final String _message;
  final bool _mayor;

  const new(this._message, {super.key, this._mayor = false});

  @override
  Widget build(BuildContext context) {
    final double fontSize = _mayor ? 18 : 16;
    final double lineHeight = _mayor ? 24 : 22;
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SereniaSpacing.sm,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.error_outline_rounded,
              color: SereniaColors.error,
              size: _mayor ? 22 : 20,
            ),
          ),
          Expanded(
            child: Text(
              _message,
              style: TextStyle(
                color: SereniaColors.text,
                fontSize: fontSize,
                height: lineHeight / fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
