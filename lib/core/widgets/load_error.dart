import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';

class LoadError extends StatelessWidget {
  final String _message;
  final VoidCallback _onRetry;

  const new({super.key, required this._message, required this._onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SereniaSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SereniaSpacing.md,
        children: [
          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SereniaColors.neutro700,
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SecondaryButton(label: 'Intentar de nuevo', onPressed: _onRetry),
        ],
      ),
    );
  }
}
