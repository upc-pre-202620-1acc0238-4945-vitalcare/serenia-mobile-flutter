import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/dashed_border.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';
import 'package:serenia_app/core/widgets/serenia_snack_bar.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/all_audios_page.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/all_photos_page.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/audio_message_card.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_link.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_photo_picker.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_photo_tile.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_samples.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/photo_review_page.dart';

class MessagesPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  static const double _playingProgress = 14 / 42;

  final List<SampleAudio> _audios = MessageSamples.audios;
  List<SamplePhoto> _photos = MessageSamples.photos;
  String? _playingId;

  void _toggle(SampleAudio audio) {
    setState(() => _playingId = _playingId == audio.id ? null : audio.id);
  }

  Future<void> _openAllAudios() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllAudiosPage(audios: _audios),
      ),
    );
  }

  Future<void> _openAllPhotos() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllPhotosPage(photos: _photos),
      ),
    );
  }

  Future<void> _sendPhoto() async {
    final Uint8List? bytes = await MessagePhotoPicker.pickFromGallery();
    if (bytes == null || !mounted) return;
    final bool? sent = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PhotoReviewPage(photo: bytes)),
    );
    if (sent != true || !mounted) return;
    setState(() {
      _photos = [
        SamplePhoto(
          owner: MessageSamples.relative,
          author: 'Tú',
          when: 'ahora',
          tint: SereniaColors.teal50,
          justSent: true,
          bytes: bytes,
        ),
        ..._photos.map(
          (photo) => SamplePhoto(
            owner: photo.owner,
            author: photo.author,
            when: photo.when,
            tint: photo.tint,
            bytes: photo.bytes,
          ),
        ),
      ];
    });
    showSereniaSnackBar(
      context,
      'Foto enviada. ${MessageSamples.olderAdult} ya puede verla.',
    );
  }

  Widget _audiosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SereniaSpacing.gap,
      children: [
        MessageSectionHeader(
          title: 'Audios de ${MessageSamples.olderAdult}',
          onSeeAll: _openAllAudios,
        ),
        if (_audios.isEmpty)
          const _NoAudiosCard()
        else
          for (final SampleAudio audio in _audios.take(3))
            AudioMessageCard(
              audio: audio,
              playing: _playingId == audio.id,
              progress: _playingProgress,
              onToggle: () => _toggle(audio),
            ),
      ],
    );
  }

  Widget _photosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SereniaSpacing.gap,
      children: [
        MessageSectionHeader(
          title: 'Fotos para ${MessageSamples.olderAdult}',
          onSeeAll: _openAllPhotos,
        ),
        const Text(
          '${MessageSamples.olderAdult} las ve en su app, en Familia › Fotos.',
          style: TextStyle(
            color: SereniaColors.neutro700,
            fontSize: 16,
            height: 24 / 16,
          ),
        ),
        MessagePhotoRow(photos: _photos.take(3).toList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  SereniaSpacing.screen,
                  SereniaSpacing.screen,
                  SereniaSpacing.screen,
                  SereniaSpacing.gap,
                ),
                children: [
                  const ScreenHeader(
                    title: 'Mensajes con ${MessageSamples.olderAdultLabel}',
                  ),
                  const SizedBox(height: SereniaSpacing.lg),
                  _audiosSection(),
                  const SizedBox(height: SereniaSpacing.lg),
                  _photosSection(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SereniaSpacing.screen,
                SereniaSpacing.sm,
                SereniaSpacing.screen,
                SereniaSpacing.gap,
              ),
              child: PrimaryButton(
                label: 'Enviarle una foto',
                icon: Icons.image_outlined,
                onPressed: _sendPhoto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoAudiosCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return DashedBorder(
      color: SereniaColors.neutro300,
      radius: SereniaRadius.md,
      dash: 7,
      gap: 5,
      child: SereniaCard(
        radius: SereniaRadius.md,
        shadow: const [],
        padding: const EdgeInsets.all(SereniaSpacing.md),
        child: Row(
          spacing: SereniaSpacing.md,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: SereniaColors.durazno200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_none_rounded,
                color: SereniaColors.durazno900,
                size: 24,
              ),
            ),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${MessageSamples.olderAdult} aún no ha enviado audios.',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: ' Cuando use «Cuéntame algo» en su app, los escucharás aquí.',
                    ),
                  ],
                ),
                style: TextStyle(
                  color: SereniaColors.text,
                  fontSize: 17,
                  height: 24 / 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
