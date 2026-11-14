import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final Widget _child;
  final Color _color;
  final double _strokeWidth;
  final double _radius;
  final double _dash;
  final double _gap;
  final bool _circle;

  const new({
    super.key,
    required this._child,
    required this._color,
    this._strokeWidth = 2,
    this._radius = 0,
    this._dash = 5,
    this._gap = 4,
    this._circle = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: _color,
        strokeWidth: _strokeWidth,
        radius: _radius,
        dash: _dash,
        gap: _gap,
        circle: _circle,
      ),
      child: _child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _radius;
  final double _dash;
  final double _gap;
  final bool _circle;

  const new({
    required this._color,
    required this._strokeWidth,
    required this._radius,
    required this._dash,
    required this._gap,
    required this._circle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = (Offset.zero & size).deflate(_strokeWidth / 2);
    final Path outline = _circle
        ? (Path()..addOval(rect))
        : (Path()..addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(_radius)),
          ));
    final Paint paint = Paint()
      ..color = _color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    for (final metric in outline.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + _dash), paint);
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate._color != _color ||
        oldDelegate._strokeWidth != _strokeWidth ||
        oldDelegate._radius != _radius ||
        oldDelegate._dash != _dash ||
        oldDelegate._gap != _gap ||
        oldDelegate._circle != _circle;
  }
}
