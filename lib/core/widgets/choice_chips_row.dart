import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class ChoiceChipsRow<T> extends StatelessWidget {
  final List<(T, String)> _options;
  final T _selected;
  final ValueChanged<T> _onSelected;

  const new({
    super.key,
    required this._options,
    required this._selected,
    required this._onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: SereniaSpacing.sm,
        children: [for (final option in _options) _chip(option)],
      ),
    );
  }

  Widget _chip((T, String) option) {
    final bool selected = option.$1 == _selected;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? SereniaColors.primary : SereniaColors.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? SereniaColors.primary : SereniaColors.neutro300,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onSelected(option.$1),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Text(
                option.$2,
                style: TextStyle(
                  color: selected
                      ? SereniaColors.onPrimary
                      : SereniaColors.text,
                  fontSize: 14,
                  height: 18 / 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
