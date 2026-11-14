import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';

class NavCard extends StatelessWidget {
  final IconData _icon;
  final Color _tint;
  final Color _iconColor;
  final String _title;
  final String? _subtitle;
  final VoidCallback _onTap;

  const new({
    super.key,
    required this._icon,
    required this._tint,
    required this._iconColor,
    required this._title,
    this._subtitle,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: SereniaCard(
        onTap: _onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: _subtitle == null ? 44 : 52),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
                child: Icon(_icon, color: _iconColor, size: 22),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: const TextStyle(
                        color: SereniaColors.text,
                        fontSize: 17,
                        height: 22 / 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (_subtitle != null)
                      Text(
                        _subtitle,
                        style: const TextStyle(
                          color: SereniaColors.neutro700,
                          fontSize: 14,
                          height: 20 / 14,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: SereniaColors.primary,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
