import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class SereniaCard extends StatelessWidget {
  final Widget _child;
  final VoidCallback? _onTap;
  final Color _color;
  final Color? _borderColor;
  final double _borderWidth;
  final double _radius;
  final List<BoxShadow> _shadow;
  final EdgeInsetsGeometry _padding;

  const new({
    super.key,
    required this._child,
    this._onTap,
    this._color = SereniaColors.surface,
    this._borderColor,
    this._borderWidth = 2,
    this._radius = SereniaRadius.lg,
    this._shadow = SereniaShadows.sm,
    this._padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(_radius);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: _shadow),
      child: Material(
        color: _color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: _borderColor == null
              ? BorderSide.none
              : BorderSide(color: _borderColor, width: _borderWidth),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _onTap,
          child: Padding(padding: _padding, child: _child),
        ),
      ),
    );
  }
}
