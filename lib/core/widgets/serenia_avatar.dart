import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';

enum AvatarTone { me, other }

class SereniaAvatar extends StatelessWidget {
  final String _name;
  final ImageProvider? _photo;
  final AvatarTone _tone;
  final double _size;

  const new({
    super.key,
    required this._name,
    this._photo,
    this._tone = AvatarTone.other,
    this._size = 48,
  });

  static String initialsOf(String name) {
    final List<String> words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = _tone == AvatarTone.me
        ? SereniaColors.verde300
        : SereniaColors.durazno200;
    final Color foreground = _tone == AvatarTone.me
        ? SereniaColors.verde900
        : SereniaColors.durazno900;

    return Semantics(
      label: _name,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: _size,
        height: _size,
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: _photo == null
            ? _Initials(name: _name, size: _size, color: foreground)
            : Image(
                image: _photo,
                width: _size,
                height: _size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _Initials(name: _name, size: _size, color: foreground),
              ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  final String _name;
  final double _size;
  final Color _color;

  const new({required this._name, required this._size, required this._color});

  @override
  Widget build(BuildContext context) {
    return Text(
      SereniaAvatar.initialsOf(_name),
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        color: _color,
        fontSize: (_size * 0.36).roundToDouble(),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
