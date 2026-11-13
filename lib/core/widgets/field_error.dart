import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class FieldError extends StatelessWidget {
  final String _message;

  const new(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SereniaSpacing.sm,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.error_outline_rounded,
              color: SereniaColors.error,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              _message,
              style: const TextStyle(
                color: SereniaColors.text,
                fontSize: 16,
                height: 22 / 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
