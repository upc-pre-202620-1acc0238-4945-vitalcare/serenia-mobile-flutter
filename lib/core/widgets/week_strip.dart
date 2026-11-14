import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/dashed_border.dart';

class ShiftDay {
  final String weekday;
  final String number;
  final String who;
  final bool isFree;
  final String semanticsLabel;

  const new({
    required this.weekday,
    required this.number,
    required this.who,
    required this.isFree,
    required this.semanticsLabel,
  });
}

class WeekStrip extends StatelessWidget {
  final String _rangeLabel;
  final List<ShiftDay> _days;
  final int _selected;
  final ValueChanged<int> _onSelect;
  final VoidCallback? _onPrev;
  final VoidCallback? _onNext;

  const new({
    super.key,
    required this._rangeLabel,
    required this._days,
    required this._selected,
    required this._onSelect,
    this._onPrev,
    this._onNext,
  });

  Widget _arrow(IconData icon, String tooltip, VoidCallback? onPressed) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: SereniaSizes.weekArrow),
      color: SereniaColors.primary,
      disabledColor: SereniaColors.neutro400,
      constraints: const BoxConstraints(
        minWidth: SereniaTouch.min,
        minHeight: SereniaTouch.min,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SereniaSpacing.gap,
      children: [
        Row(
          children: [
            _arrow(Icons.chevron_left_rounded, 'Semana anterior', _onPrev),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _rangeLabel,
                  textAlign: TextAlign.center,
                  style: SereniaTypography.weekRange.copyWith(
                    color: SereniaColors.text,
                  ),
                ),
              ),
            ),
            _arrow(Icons.chevron_right_rounded, 'Semana siguiente', _onNext),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: SereniaSpacing.xs,
          children: [
            for (int index = 0; index < _days.length; index++)
              Expanded(
                child: _DayCell(
                  day: _days[index],
                  selected: index == _selected,
                  onTap: () => _onSelect(index),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final ShiftDay _day;
  final bool _selected;
  final VoidCallback _onTap;

  const new({
    required this._day,
    required this._selected,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color foreground = _selected
        ? SereniaColors.neutro50
        : SereniaColors.text;
    final bool dashed = _day.isFree && !_selected;
    final BorderRadius radius = BorderRadius.circular(SereniaRadius.sm);

    final Widget content = Material(
      color: _selected ? SereniaColors.primary : SereniaColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: dashed
            ? BorderSide.none
            : BorderSide(
                color: _selected
                    ? SereniaColors.primary
                    : SereniaColors.neutro200,
                width: 2,
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SereniaSizes.weekCell),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SereniaSizes.weekCellPadding,
              horizontal: SereniaSpacing.xxs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: SereniaSpacing.xxs,
              children: [
                Text(
                  _day.weekday,
                  style: SereniaTypography.weekDay.copyWith(color: foreground),
                ),
                Text(
                  _day.number,
                  style: SereniaTypography.weekNumber.copyWith(
                    color: foreground,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _day.who,
                    maxLines: 1,
                    style: SereniaTypography.weekWho.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      selected: _selected,
      label: _day.semanticsLabel,
      excludeSemantics: true,
      child: dashed
          ? DashedBorder(
              color: SereniaColors.neutro400,
              radius: SereniaRadius.sm,
              child: content,
            )
          : content,
    );
  }
}
