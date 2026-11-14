import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_link.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_photo_picker.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/message_samples.dart';

class PhotoReviewPage extends StatefulWidget {
  final Uint8List _photo;

  const new({super.key, required this._photo});

  @override
  State<PhotoReviewPage> createState() => _PhotoReviewPageState();
}

class _PhotoReviewPageState extends State<PhotoReviewPage> {
  late Uint8List _photo = widget._photo;

  Future<void> _chooseAnother() async {
    final Uint8List? bytes = await MessagePhotoPicker.pickFromGallery();
    if (bytes == null || !mounted) return;
    setState(() => _photo = bytes);
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
                  SereniaSpacing.sm,
                  SereniaSpacing.screen,
                  SereniaSpacing.cardInset,
                ),
                children: [
                  const BackLink(parent: 'Mensajes'),
                  const SizedBox(height: SereniaSpacing.gap),
                  const ScreenHeader(title: '¿Le envías esta foto?'),
                  const SizedBox(height: SereniaSpacing.md),
                  Semantics(
                    image: true,
                    label: 'Foto elegida de tu galería',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(SereniaRadius.xl),
                      child: SizedBox(
                        height: 360,
                        child: ColoredBox(
                          color: SereniaColors.teal50,
                          child: Image.memory(
                            _photo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SereniaSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: UnderlinedLink(
                      label: 'Elegir otra foto',
                      onPressed: _chooseAnother,
                    ),
                  ),
                  const SizedBox(height: SereniaSpacing.sm),
                  const Text(
                    '${MessageSamples.olderAdult} la verá en su app, en Familia › Fotos, con tu nombre.',
                    style: TextStyle(
                      color: SereniaColors.neutro700,
                      fontSize: 17,
                      height: 26 / 17,
                    ),
                  ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: SereniaSpacing.gap,
                children: [
                  PrimaryButton(
                    label: 'Enviar a ${MessageSamples.olderAdultLabel}',
                    icon: Icons.send_outlined,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  AffectiveButton(
                    label: 'Cancelar',
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
