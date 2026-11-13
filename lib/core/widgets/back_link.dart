import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class BackLink extends StatelessWidget {
  final String _parent;
  final VoidCallback? _onTap;

  const new(this._parent, {super.key, this._onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        button: true,
        label: 'Volver a $_parent',
        excludeSemantics: true,
        child: InkWell(
          onTap: _onTap ?? () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(SereniaRadius.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: SereniaTouch.min),
            child: Padding(
              padding: const EdgeInsets.only(right: SereniaSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  const Icon(
                    Icons.chevron_left_rounded,
                    color: SereniaColors.neutro700,
                    size: 26,
                  ),
                  Text(
                    _parent,
                    style: const TextStyle(
                      color: SereniaColors.neutro700,
                      fontSize: 16,
                      height: 22 / 16,
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
