import 'package:flutter/material.dart';

class SereniaTypography {
  static const String fontFamily = 'Nunito';

  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight, {
    double tracking = 0,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: tracking * size,
    );
  }

  static final TextTheme familiar = TextTheme(
    displayLarge: _style(48, 54, FontWeight.w800, tracking: -0.01),
    displayMedium: _style(36, 42, FontWeight.w800, tracking: -0.005),
    displaySmall: _style(30, 36, FontWeight.w800, tracking: -0.005),
    headlineLarge: _style(28, 34, FontWeight.w800),
    headlineMedium: _style(24, 30, FontWeight.w700),
    headlineSmall: _style(20, 26, FontWeight.w700),
    titleLarge: _style(18, 24, FontWeight.w700),
    titleMedium: _style(16, 22, FontWeight.w700),
    titleSmall: _style(15, 20, FontWeight.w800),
    bodyLarge: _style(18, 28, FontWeight.w400),
    bodyMedium: _style(16, 24, FontWeight.w400),
    bodySmall: _style(14, 20, FontWeight.w400, tracking: 0.001),
    labelLarge: _style(16, 20, FontWeight.w800, tracking: 0.002),
    labelMedium: _style(12, 16, FontWeight.w600, tracking: 0.002),
    labelSmall: _style(12, 16, FontWeight.w500, tracking: 0.08),
  );

  static final TextTheme mayor = TextTheme(
    displayLarge: _style(56, 62, FontWeight.w800, tracking: -0.01),
    displayMedium: _style(40, 46, FontWeight.w800, tracking: -0.005),
    displaySmall: _style(34, 40, FontWeight.w800, tracking: -0.005),
    headlineLarge: _style(28, 34, FontWeight.w800),
    headlineMedium: _style(28, 34, FontWeight.w700),
    headlineSmall: _style(24, 30, FontWeight.w700),
    titleLarge: _style(22, 28, FontWeight.w700),
    titleMedium: _style(20, 26, FontWeight.w700),
    titleSmall: _style(16, 22, FontWeight.w800),
    bodyLarge: _style(22, 32, FontWeight.w500),
    bodyMedium: _style(20, 30, FontWeight.w500),
    bodySmall: _style(18, 26, FontWeight.w500, tracking: 0.001),
    labelLarge: _style(22, 26, FontWeight.w800, tracking: 0.002),
    labelMedium: _style(16, 22, FontWeight.w700, tracking: 0.002),
    labelSmall: _style(16, 20, FontWeight.w600, tracking: 0.08),
  );

  static final TextStyle cardTitle = _style(17, 22, FontWeight.w800);
  static final TextStyle cardSubtitle = _style(14, 20, FontWeight.w400);
  static final TextStyle overline = _style(
    13,
    16,
    FontWeight.w700,
    tracking: 0.06,
  );
  static final TextStyle dayTitle = _style(20, 26, FontWeight.w800);
  static final TextStyle cardBody = _style(15, 22, FontWeight.w400);
  static final TextStyle cardBodyStrong = _style(15, 22, FontWeight.w700);
  static final TextStyle weekRange = _style(16, 22, FontWeight.w800);
  static final TextStyle weekDay = _style(12, 16, FontWeight.w700);
  static final TextStyle weekNumber = _style(20, 24, FontWeight.w800);
  static final TextStyle weekWho = _style(11, 14, FontWeight.w700);
}
