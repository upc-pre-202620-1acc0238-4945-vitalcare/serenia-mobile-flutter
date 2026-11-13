import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class BackLink extends StatelessWidget {
  final String? _parent;
  final VoidCallback? _onTap;
  final bool _mayor;

  const new({super.key, this._parent, this._onTap, this._mayor = false});

  @override
  Widget build(BuildContext context) {
    final double fontSize = _mayor ? 18 : 16;
    final double lineHeight = _mayor ? 24 : 22;
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        button: true,
        label: _parent == null ? 'Atrás' : 'Volver a $_parent',
        excludeSemantics: true,
        child: InkWell(
          onTap: _onTap ?? () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(SereniaRadius.sm),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _mayor ? 56 : SereniaTouch.min,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: SereniaSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    color: SereniaColors.neutro700,
                    size: _mayor ? 30 : 26,
                  ),
                  Text(
                    _parent ?? 'Atrás',
                    style: TextStyle(
                      color: SereniaColors.neutro700,
                      fontSize: fontSize,
                      height: lineHeight / fontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
