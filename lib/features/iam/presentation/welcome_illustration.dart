import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class WelcomeIllustration extends StatelessWidget {
  const new({super.key});

  static const String description =
      'Rosa le cuenta a su hija Lucía que amaneció muy bien, y Lucía le responde con cariño.';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: description,
      excludeSemantics: true,
      child: SizedBox(
        height: 330,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _DashedCurvePainter()),
            ),
            const Positioned(
              left: 144,
              top: 70,
              child: _RingedCircle(
                size: 44,
                ring: 6,
                color: SereniaColors.durazno300,
                ringColor: Color(0x40F2D8B5),
                child: Icon(
                  Icons.favorite_rounded,
                  color: SereniaColors.error,
                  size: 24,
                ),
              ),
            ),
            const Positioned(
              left: 2,
              top: 106,
              child: _RingedCircle(
                size: 132,
                ring: 10,
                color: SereniaColors.durazno200,
                ringColor: Color(0x2EF2D8B5),
                child: Icon(
                  Icons.sentiment_satisfied_rounded,
                  color: SereniaColors.durazno900,
                  size: 76,
                ),
              ),
            ),
            const Positioned(
              right: 2,
              top: -2,
              child: _RingedCircle(
                size: 104,
                ring: 10,
                color: SereniaColors.verde300,
                ringColor: Color(0x2EA9D8B8),
                child: Icon(
                  Icons.sentiment_satisfied_rounded,
                  color: SereniaColors.verde900,
                  size: 60,
                ),
              ),
            ),
            const Positioned(
              right: 0,
              top: 132,
              child: _MessageBubble(
                sender: 'Lucía, su hija',
                message: '¡Qué bueno, mamá!',
                senderColor: SereniaColors.durazno800,
                background: SereniaColors.durazno100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              top: 266,
              child: _MessageBubble(
                sender: 'Rosa · 8:00 a. m.',
                message: 'Amanecí muy bien',
                senderColor: SereniaColors.teal800,
                background: SereniaColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingedCircle extends StatelessWidget {
  final double _size;
  final double _ring;
  final Color _color;
  final Color _ringColor;
  final Widget _child;

  const new({
    required this._size,
    required this._ring,
    required this._color,
    required this._ringColor,
    required this._child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size + _ring * 2,
      height: _size + _ring * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: _ringColor, shape: BoxShape.circle),
      child: Container(
        width: _size,
        height: _size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        child: _child,
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String _sender;
  final String _message;
  final Color _senderColor;
  final Color _background;
  final BorderRadius _borderRadius;

  const new({
    required this._sender,
    required this._message,
    required this._senderColor,
    required this._background,
    required this._borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: _borderRadius,
        boxShadow: SereniaShadows.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _sender,
            style: TextStyle(
              color: _senderColor,
              fontSize: 16,
              height: 20 / 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            _message,
            style: const TextStyle(
              color: SereniaColors.text,
              fontSize: 20,
              height: 26 / 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCurvePainter extends CustomPainter {
  const new();

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 342;
    final Path curve = Path()
      ..moveTo(80 * scale, 180)
      ..cubicTo(110 * scale, 70, 210 * scale, 40, 282 * scale, 64);
    final Paint paint = Paint()
      ..color = SereniaColors.durazno300
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final metric in curve.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 2), paint);
        distance += 14;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedCurvePainter oldDelegate) => false;
}
