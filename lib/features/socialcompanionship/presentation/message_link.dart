import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class UnderlinedLink extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;

  const new({super.key, required this._label, required this._onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: _onPressed,
        borderRadius: BorderRadius.circular(SereniaRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SereniaTouch.min),
          child: Align(
            widthFactor: 1,
            child: Text(
              _label,
              style: const TextStyle(
                color: SereniaColors.primary,
                fontSize: 16,
                height: 22 / 16,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                decorationColor: SereniaColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageSectionHeader extends StatelessWidget {
  final String _title;
  final VoidCallback _onSeeAll;

  const new({super.key, required this._title, required this._onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: SereniaSpacing.sm,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              _title,
              style: const TextStyle(
                color: SereniaColors.text,
                fontSize: 20,
                height: 26 / 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        UnderlinedLink(label: 'Ver todos', onPressed: _onSeeAll),
      ],
    );
  }
}
