import 'package:flutter/painting.dart';

class SereniaSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
  static const double screen = 20;
}

class SereniaRadius {
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;
  static const double xl = 36;
  static const double pill = 999;
}

class SereniaShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x141F6F66), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x291F6F66), offset: Offset(0, 6), blurRadius: 16),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x381F6F66), offset: Offset(0, 16), blurRadius: 36),
  ];
}

class SereniaTouch {
  static const double min = 48;
  static const double button = 52;
  static const double accessButton = 56;
  static const double navigationItem = 60;
}
