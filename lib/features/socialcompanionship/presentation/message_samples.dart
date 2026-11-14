import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:serenia_app/core/serenia_colors.dart';

// Datos de ejemplo tomados de los mockups. Solo sirven para dibujar las
// pantallas; cuando exista la capa de datos se reemplazan por los reales.

class MessageSamples {
  static const String olderAdult = 'Rosa';
  static const String olderAdultLabel = 'Mamá Rosa';
  static const String relative = 'Lucía';

  static const List<SampleAudio> audios = [
    SampleAudio(
      id: 'audio-1',
      when: 'Hoy, 7:52 a. m.',
      seconds: 42,
      isNew: true,
    ),
    SampleAudio(id: 'audio-2', when: 'Martes, 6:15 p. m.', seconds: 65),
    SampleAudio(id: 'audio-3', when: 'Domingo, 11:30 a. m.', seconds: 28),
    SampleAudio(id: 'audio-4', when: 'Sábado, 5:10 p. m.', seconds: 51),
    SampleAudio(id: 'audio-5', when: '3 de nov, 9:05 a. m.', seconds: 34),
  ];

  static const List<SamplePhoto> photos = [
    SamplePhoto(
      owner: 'Lucía',
      author: 'Tú',
      when: 'lunes',
      tint: SereniaColors.verde100,
    ),
    SamplePhoto(
      owner: 'Martín',
      author: 'Martín',
      when: 'domingo',
      tint: SereniaColors.durazno100,
    ),
    SamplePhoto(
      owner: 'Lucía',
      author: 'Tú',
      when: 'sáb.',
      tint: SereniaColors.teal50,
    ),
    SamplePhoto(
      owner: 'Martín',
      author: 'Martín',
      when: '2 de nov',
      tint: SereniaColors.verde100,
    ),
  ];
}

class SampleAudio {
  final String id;
  final String when;
  final int seconds;
  final bool isNew;

  const new({
    required this.id,
    required this.when,
    required this.seconds,
    this.isNew = false,
  });

  Duration get length => Duration(seconds: seconds);
}

class SamplePhoto {
  final String owner;
  final String author;
  final String when;
  final Color tint;
  final bool justSent;
  final Uint8List? bytes;

  const new({
    required this.owner,
    required this.author,
    required this.when,
    required this.tint,
    this.justSent = false,
    this.bytes,
  });

  String get caption => '$author · $when';

  String get placeholder {
    return justSent && bytes == null ? '[Tu foto]' : '[Foto de $owner]';
  }
}
