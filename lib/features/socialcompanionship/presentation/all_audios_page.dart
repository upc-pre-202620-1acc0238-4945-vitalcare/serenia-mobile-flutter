import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/audio_message_card.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_samples.dart';

class AllAudiosPage extends StatefulWidget {
  final List<SampleAudio> _audios;

  const new({super.key, required this._audios});

  @override
  State<AllAudiosPage> createState() => _AllAudiosPageState();
}

class _AllAudiosPageState extends State<AllAudiosPage> {
  static const double _playingProgress = 14 / 42;

  String? _playingId;

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
            const ScreenHeader(title: 'Audios de ${MessageSamples.olderAdult}'),
            for (final SampleAudio audio in widget._audios) ...[
              const SizedBox(height: SereniaSpacing.gap),
              AudioMessageCard(
                audio: audio,
                playing: _playingId == audio.id,
                progress: _playingProgress,
                onToggle: () => setState(
                  () => _playingId = _playingId == audio.id ? null : audio.id,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
