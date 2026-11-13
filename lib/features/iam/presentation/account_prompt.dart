import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class AccountPrompt extends StatelessWidget {
  final String _question;
  final String _action;
  final VoidCallback _onTap;
  final bool _mayor;

  const new({
    super.key,
    required this._question,
    required this._action,
    required this._onTap,
    this._mayor = false,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = _mayor ? 18 : 16;
    final double lineHeight = _mayor ? 24 : 22;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(
          _question,
          style: TextStyle(
            color: SereniaColors.neutro700,
            fontSize: fontSize,
            height: lineHeight / fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        Semantics(
          button: true,
          child: InkWell(
            onTap: _onTap,
            borderRadius: BorderRadius.circular(SereniaRadius.sm),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: SereniaTouch.min),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SereniaSpacing.xs,
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    _action,
                    style: TextStyle(
                      color: SereniaColors.primary,
                      fontSize: fontSize,
                      height: lineHeight / fontSize,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      decorationColor: SereniaColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
