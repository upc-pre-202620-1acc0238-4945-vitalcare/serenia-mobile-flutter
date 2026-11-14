import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';

class MemberRadioTile extends StatelessWidget {
  final SereniaAvatar _avatar;
  final String _name;
  final String _relation;
  final bool _selected;
  final VoidCallback _onTap;

  const new({
    super.key,
    required this._avatar,
    required this._name,
    required this._relation,
    required this._selected,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(SereniaRadius.md);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      label: '$_name, $_relation',
      excludeSemantics: true,
      child: Material(
        color: SereniaColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: _selected ? SereniaColors.primary : SereniaColors.neutro200,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SereniaSizes.memberRadioTile,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SereniaSpacing.cardInset,
                vertical: SereniaSpacing.sm,
              ),
              child: Row(
                spacing: SereniaSpacing.gap,
                children: [
                  Container(
                    width: SereniaSizes.radio,
                    height: SereniaSizes.radio,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selected
                            ? SereniaColors.primary
                            : SereniaColors.borderControl,
                        width: 2,
                      ),
                    ),
                    child: _selected
                        ? Container(
                            width: SereniaSizes.radioDot,
                            height: SereniaSizes.radioDot,
                            decoration: const BoxDecoration(
                              color: SereniaColors.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                  _avatar,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: SereniaTypography.listTitle.copyWith(
                            color: SereniaColors.text,
                          ),
                        ),
                        Text(
                          _relation,
                          style: SereniaTypography.cardSubtitle.copyWith(
                            color: SereniaColors.neutro700,
                          ),
                        ),
                      ],
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
