import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';

class SectionLabel extends StatelessWidget {
  final String _text;

  const new(this._text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        _text,
        style: const TextStyle(
          color: SereniaColors.neutro700,
          fontSize: 15,
          height: 20 / 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
