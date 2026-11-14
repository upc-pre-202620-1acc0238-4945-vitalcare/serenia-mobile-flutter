import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/field_error.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';

class NoteCard extends StatelessWidget {
  final SereniaAvatar _avatar;
  final String _author;
  final String _when;
  final String _text;
  final bool _mine;
  final bool _editing;
  final bool _saving;
  final String? _error;
  final TextEditingController? _controller;
  final VoidCallback? _onEdit;
  final VoidCallback? _onSave;
  final VoidCallback? _onCancel;

  const new({
    super.key,
    required this._avatar,
    required this._author,
    required this._when,
    required this._text,
    required this._mine,
    this._editing = false,
    this._saving = false,
    this._error,
    this._controller,
    this._onEdit,
    this._onSave,
    this._onCancel,
  });

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(SereniaRadius.sm),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _editor() {
    final bool hasError = _error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SereniaSpacing.sm,
      children: [
        Semantics(
          label: 'Editar tu nota',
          textField: true,
          child: TextField(
            controller: _controller,
            autofocus: true,
            minLines: SereniaSizes.noteLines,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: SereniaTypography.noteText.copyWith(
              color: SereniaColors.text,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: SereniaColors.surface,
              contentPadding: const EdgeInsets.all(SereniaSpacing.gap),
              enabledBorder: _border(
                hasError ? SereniaColors.error : SereniaColors.primary,
                SereniaSizes.focusBorder,
              ),
              focusedBorder: _border(
                hasError ? SereniaColors.error : SereniaColors.primary,
                SereniaSizes.focusBorder,
              ),
            ),
          ),
        ),
        if (_error != null) FieldError(_error),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: SereniaSpacing.sm,
          children: [
            Expanded(
              child: PrimaryButton(
                label: 'Guardar',
                loading: _saving,
                onPressed: _onSave,
              ),
            ),
            Expanded(
              child: AffectiveButton(
                label: 'Cancelar',
                onPressed: _saving ? null : _onCancel,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editLink() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        button: true,
        label: 'Editar tu nota',
        excludeSemantics: true,
        child: InkWell(
          onTap: _onEdit,
          borderRadius: BorderRadius.circular(SereniaRadius.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: SereniaTouch.min),
            child: Padding(
              padding: const EdgeInsets.only(right: SereniaSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: SereniaSpacing.xs,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    color: SereniaColors.primary,
                    size: SereniaSizes.inlineIcon,
                  ),
                  Text(
                    'Editar',
                    style: SereniaTypography.linkAction.copyWith(
                      color: SereniaColors.primary,
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

  @override
  Widget build(BuildContext context) {
    return SereniaCard(
      radius: SereniaRadius.md,
      padding: const EdgeInsets.all(SereniaSpacing.cardInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SereniaSpacing.sm,
        children: [
          Row(
            spacing: SereniaSpacing.tight,
            children: [
              _avatar,
              Flexible(
                child: Text(
                  _author,
                  style: SereniaTypography.noteAuthor.copyWith(
                    color: SereniaColors.text,
                  ),
                ),
              ),
              Text(
                '· $_when',
                style: SereniaTypography.noteMeta.copyWith(
                  color: SereniaColors.neutro700,
                ),
              ),
            ],
          ),
          if (_editing)
            _editor()
          else ...[
            Text(
              _text,
              style: SereniaTypography.noteText.copyWith(
                color: SereniaColors.text,
              ),
            ),
            if (_mine && _onEdit != null) _editLink(),
          ],
        ],
      ),
    );
  }
}
