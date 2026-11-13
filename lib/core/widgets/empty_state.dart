import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class EmptyState extends StatelessWidget {
  final IconData _icon;
  final Color _tint;
  final Color _iconColor;
  final String _title;
  final String _body;

  const new({
    super.key,
    required this._icon,
    required this._tint,
    required this._iconColor,
    required this._title,
    required this._body,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SereniaSpacing.md,
          0,
          SereniaSpacing.md,
          60,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
              child: Icon(_icon, color: _iconColor, size: 48),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: SereniaColors.text,
                  fontSize: 22,
                  height: 28 / 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              _body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SereniaColors.neutro700,
                fontSize: 17,
                height: 26 / 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
