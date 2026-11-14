import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

enum ChipTone {
  help(SereniaColors.errorBg, SereniaColors.errorText),
  noAnswer(SereniaColors.warningBg, SereniaColors.warningText),
  pending(SereniaColors.error, SereniaColors.neutro50),
  attending(SereniaColors.teal100, SereniaColors.teal800),
  done(SereniaColors.successBg, SereniaColors.success),
  neutral(SereniaColors.neutro200, SereniaColors.neutro800),
  fresh(SereniaColors.durazno800, SereniaColors.neutro50);

  final Color background;
  final Color foreground;

  const ChipTone(this.background, this.foreground);
}

class StatusChip extends StatelessWidget {
  final String _label;
  final ChipTone _tone;
  final IconData? _icon;

  const new({super.key, required this._label, required this._tone, this._icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: _icon == null ? 3 : 2,
      ),
      decoration: BoxDecoration(
        color: _tone.background,
        borderRadius: BorderRadius.circular(SereniaRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: SereniaSpacing.xs,
        children: [
          if (_icon != null) Icon(_icon, color: _tone.foreground, size: 16),
          Text(
            _label,
            style: TextStyle(
              color: _tone.foreground,
              fontSize: 13,
              height: 18 / 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
