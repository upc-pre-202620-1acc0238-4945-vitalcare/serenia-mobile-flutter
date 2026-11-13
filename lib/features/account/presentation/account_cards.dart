import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';

class ProfileCard extends StatelessWidget {
  final String _fullName;
  final ImageProvider? _photo;
  final VoidCallback _onTap;

  const new({
    super.key,
    required this._fullName,
    this._photo,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: SereniaCard(
        onTap: _onTap,
        color: SereniaColors.durazno100,
        borderColor: SereniaColors.durazno300,
        shadow: const [],
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Row(
            spacing: 14,
            children: [
              SereniaAvatar(
                name: _fullName,
                photo: _photo,
                tone: AvatarTone.me,
                size: 56,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fullName,
                      style: const TextStyle(
                        color: SereniaColors.text,
                        fontSize: 19,
                        height: 24 / 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Editar mis datos y foto',
                      style: TextStyle(
                        color: SereniaColors.durazno800,
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: SereniaColors.durazno800,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkCard extends StatelessWidget {
  final String _olderAdultName;
  final ImageProvider? _photo;
  final String _relationship;
  final VoidCallback _onTap;

  const new({
    super.key,
    required this._olderAdultName,
    this._photo,
    required this._relationship,
    required this._onTap,
  });

  String get _firstName => _olderAdultName.trim().split(RegExp(r'\s+')).first;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: SereniaCard(
        onTap: _onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            spacing: 12,
            children: [
              SereniaAvatar(name: _olderAdultName, photo: _photo, size: 44),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acompañas a $_firstName',
                      style: const TextStyle(
                        color: SereniaColors.text,
                        fontSize: 16,
                        height: 22 / 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Eres su $_relationship',
                      style: const TextStyle(
                        color: SereniaColors.neutro700,
                        fontSize: 14,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: SereniaSpacing.xs),
                child: Text(
                  'Ver círculo',
                  style: TextStyle(
                    color: SereniaColors.primary,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
