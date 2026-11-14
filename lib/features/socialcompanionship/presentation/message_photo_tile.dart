import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_samples.dart';

class MessagePhotoTile extends StatelessWidget {
  final SamplePhoto _photo;

  const new({super.key, required this._photo});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Foto, ${_photo.caption}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SereniaSpacing.sm,
        children: [
          AspectRatio(
            aspectRatio: 1.17,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SereniaRadius.md),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: _photo.tint),
                  if (_photo.bytes != null)
                    Image.memory(_photo.bytes!, fit: BoxFit.cover)
                  else
                    _Placeholder(_photo.placeholder),
                  if (_photo.justSent)
                    const Positioned(top: 8, left: 8, child: _NowBadge()),
                ],
              ),
            ),
          ),
          Text(
            _photo.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SereniaColors.neutro700,
              fontSize: 15,
              height: 20 / 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String _label;

  const new(this._label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SereniaSpacing.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: SereniaSpacing.sm,
        children: [
          const Icon(
            Icons.image_outlined,
            color: SereniaColors.neutro600,
            size: 26,
          ),
          Text(
            _label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SereniaColors.neutro600,
              fontSize: 13,
              height: 18 / 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NowBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SereniaColors.teal800,
        borderRadius: BorderRadius.circular(SereniaRadius.pill),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          'Ahora',
          style: TextStyle(
            color: SereniaColors.neutro50,
            fontSize: 13,
            height: 16 / 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class MessagePhotoRow extends StatelessWidget {
  final List<SamplePhoto> _photos;

  const new({super.key, required this._photos});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SereniaSpacing.gap,
      children: [
        for (final SamplePhoto photo in _photos)
          Expanded(child: MessagePhotoTile(photo: photo)),
        for (int i = _photos.length; i < 3; i++) const Spacer(),
      ],
    );
  }
}
