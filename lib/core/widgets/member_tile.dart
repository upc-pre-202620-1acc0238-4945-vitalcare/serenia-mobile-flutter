import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';

class MemberTile extends StatelessWidget {
  final SereniaAvatar _avatar;
  final String _name;
  final String _relation;
  final bool _isMe;

  const new({
    super.key,
    required this._avatar,
    required this._name,
    required this._relation,
    this._isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    final String name = _isMe ? '$_name (tú)' : _name;
    return Semantics(
      container: true,
      label: '$name, $_relation',
      excludeSemantics: true,
      child: SereniaCard(
        radius: SereniaRadius.md,
        padding: const EdgeInsets.symmetric(
          horizontal: SereniaSpacing.cardInset,
          vertical: SereniaSpacing.tight,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: SereniaSizes.memberTile - 2 * SereniaSpacing.tight,
          ),
          child: Row(
            spacing: SereniaSpacing.gap,
            children: [
              _avatar,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: SereniaTypography.cardTitle.copyWith(
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
    );
  }
}
