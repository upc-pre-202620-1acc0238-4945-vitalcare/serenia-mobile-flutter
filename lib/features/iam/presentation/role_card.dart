import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class RoleCard extends StatelessWidget {
  final String _title;
  final String _description;
  final IconData _icon;
  final Color _background;
  final Color _border;
  final Color _iconBackground;
  final Color _iconColor;
  final VoidCallback _onTap;

  const new({
    super.key,
    required this._title,
    required this._description,
    required this._icon,
    required this._background,
    required this._border,
    required this._iconBackground,
    required this._iconColor,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(SereniaRadius.lg);
    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: SereniaShadows.sm,
        ),
        child: Material(
          color: _background,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: _border, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                child: Row(
                  spacing: SereniaSpacing.md,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: _iconBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_icon, color: _iconColor, size: 36),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: SereniaSpacing.xs,
                        children: [
                          Text(
                            _title,
                            style: const TextStyle(
                              color: SereniaColors.text,
                              fontSize: 24,
                              height: 30 / 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            _description,
                            style: const TextStyle(
                              color: SereniaColors.neutro700,
                              fontSize: 18,
                              height: 24 / 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: SereniaColors.primary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
