import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class OptionGrid<T> extends StatelessWidget {
  final List<(T, String)> _options;
  final T? _selected;
  final ValueChanged<T> _onSelected;

  const new({
    super.key,
    required this._options,
    required this._selected,
    required this._onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    for (int index = 0; index < _options.length; index += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Expanded(child: _option(_options[index])),
              Expanded(
                child: index + 1 < _options.length
                    ? _option(_options[index + 1])
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(spacing: 12, children: rows);
  }

  Widget _option((T, String) option) {
    final bool selected = option.$1 == _selected;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? SereniaColors.primary : SereniaColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SereniaRadius.sm),
          side: BorderSide(
            color: selected ? SereniaColors.primary : SereniaColors.neutro300,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onSelected(option.$1),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SereniaSpacing.sm,
                vertical: SereniaSpacing.sm,
              ),
              child: Center(
                child: Text(
                  option.$2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? SereniaColors.onPrimary
                        : SereniaColors.text,
                    fontSize: 16,
                    height: 20 / 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
