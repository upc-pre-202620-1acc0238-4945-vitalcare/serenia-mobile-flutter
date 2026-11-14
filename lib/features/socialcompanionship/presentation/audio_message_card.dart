import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_samples.dart';

class AudioMessageCard extends StatelessWidget {
  final SampleAudio _audio;
  final bool _playing;
  final double _progress;
  final VoidCallback _onToggle;

  const new({
    super.key,
    required this._audio,
    required this._playing,
    required this._progress,
    required this._onToggle,
  });

  static String _clock(Duration duration) {
    final String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '${duration.inMinutes}:$seconds';
  }

  String get _time {
    if (!_playing) return _clock(_audio.length);
    final Duration elapsed = Duration(
      seconds: (_audio.seconds * _progress).round(),
    );
    return '${_clock(elapsed)} / ${_clock(_audio.length)}';
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle meta = TextStyle(
      color: SereniaColors.neutro700,
      fontSize: 15,
      height: 20 / 15,
    );
    return SereniaCard(
      color: _playing ? SereniaColors.durazno100 : SereniaColors.surface,
      radius: SereniaRadius.md,
      padding: const EdgeInsets.all(SereniaSpacing.cardInset),
      child: Row(
        spacing: SereniaSpacing.md,
        children: [
          Semantics(
            button: true,
            label: _playing ? 'Pausar audio' : 'Reproducir audio',
            excludeSemantics: true,
            child: Material(
              color: SereniaColors.primary,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _onToggle,
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(
                    _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: SereniaColors.onPrimary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Row(
                  spacing: SereniaSpacing.sm,
                  children: [
                    const Flexible(
                      child: Text(
                        'Audio de ${MessageSamples.olderAdult}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SereniaColors.text,
                          fontSize: 18,
                          height: 24 / 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (_audio.isNew) const _NewBadge(),
                  ],
                ),
                _ProgressBar(_playing ? _progress : 0),
                Row(
                  children: [
                    Expanded(child: Text(_audio.when, style: meta)),
                    Text(_time, style: meta),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SereniaColors.durazno800,
        borderRadius: BorderRadius.circular(SereniaRadius.pill),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          'Nuevo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            height: 16 / 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double _fraction;

  const new(this._fraction);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SereniaRadius.pill),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: SereniaColors.neutro200),
            ),
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _fraction.clamp(0.0, 1.0),
                child: const ColoredBox(color: SereniaColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
