import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';

class InlineConfirmCard extends StatelessWidget {
  final String _title;
  final String _body;
  final String _confirmLabel;
  final String _cancelLabel;
  final VoidCallback? _onConfirm;
  final VoidCallback _onCancel;
  final bool _loading;

  const new({
    super.key,
    required this._title,
    required this._body,
    required this._confirmLabel,
    required this._cancelLabel,
    required this._onConfirm,
    required this._onCancel,
    this._loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SereniaCard(
      color: SereniaColors.durazno100,
      borderColor: SereniaColors.durazno400,
      shadow: SereniaShadows.md,
      padding: const EdgeInsets.all(SereniaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Semantics(
            header: true,
            liveRegion: true,
            child: Text(
              _title,
              style: const TextStyle(
                color: SereniaColors.text,
                fontSize: 19,
                height: 24 / 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            _body,
            style: const TextStyle(
              color: SereniaColors.neutro700,
              fontSize: 15,
              height: 22 / 15,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Expanded(
                child: PrimaryButton(
                  label: _confirmLabel,
                  onPressed: _onConfirm,
                  loading: _loading,
                ),
              ),
              Expanded(
                child: AffectiveButton(
                  label: _cancelLabel,
                  onPressed: _loading ? null : _onCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
