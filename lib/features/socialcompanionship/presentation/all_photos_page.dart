import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_photo_tile.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_samples.dart';

class AllPhotosPage extends StatelessWidget {
  final List<SamplePhoto> _photos;

  const new({super.key, required this._photos});

  static const int _columns = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SereniaSpacing.screen,
            SereniaSpacing.sm,
            SereniaSpacing.screen,
            SereniaSpacing.cardInset,
          ),
          children: [
            const BackLink(parent: 'Mensajes'),
            const SizedBox(height: SereniaSpacing.gap),
            const ScreenHeader(
              title: 'Fotos para ${MessageSamples.olderAdult}',
              subtitle:
                  '${MessageSamples.olderAdult} las ve en su app, en Familia › Fotos.',
            ),
            const SizedBox(height: SereniaSpacing.md),
            if (_photos.isEmpty)
              const Text(
                'Aún no le has enviado fotos.',
                style: TextStyle(
                  color: SereniaColors.neutro700,
                  fontSize: 16,
                  height: 24 / 16,
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  const double gap = SereniaSpacing.gap;
                  final double width =
                      (constraints.maxWidth - gap * (_columns - 1)) / _columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: SereniaSpacing.md,
                    children: [
                      for (final SamplePhoto photo in _photos)
                        SizedBox(
                          width: width,
                          child: MessagePhotoTile(photo: photo),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
