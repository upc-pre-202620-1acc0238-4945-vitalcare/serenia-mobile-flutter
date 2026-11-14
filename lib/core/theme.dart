import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: SereniaColors.teal700,
      surfaceTint: SereniaColors.teal700,
      onPrimary: SereniaColors.neutro50,
      primaryContainer: SereniaColors.teal100,
      onPrimaryContainer: SereniaColors.teal900,
      secondary: SereniaColors.durazno700,
      onSecondary: SereniaColors.neutro50,
      secondaryContainer: SereniaColors.durazno100,
      onSecondaryContainer: SereniaColors.durazno900,
      tertiary: SereniaColors.verde700,
      onTertiary: SereniaColors.neutro50,
      tertiaryContainer: SereniaColors.verde100,
      onTertiaryContainer: SereniaColors.verde900,
      error: SereniaColors.error,
      onError: SereniaColors.neutro50,
      errorContainer: SereniaColors.errorBg,
      onErrorContainer: SereniaColors.errorText,
      surface: SereniaColors.background,
      onSurface: SereniaColors.text,
      onSurfaceVariant: SereniaColors.textSecondary,
      outline: SereniaColors.borderControl,
      outlineVariant: SereniaColors.borderSubtle,
      shadow: SereniaColors.teal700,
      scrim: SereniaColors.neutro900,
      inverseSurface: SereniaColors.neutro800,
      inversePrimary: SereniaColors.teal200,
      onInverseSurface: SereniaColors.neutro50,
      surfaceContainerLowest: SereniaColors.neutro50,
      surfaceContainerLow: SereniaColors.neutro50,
      surfaceContainer: SereniaColors.neutro50,
      surfaceContainerHigh: SereniaColors.neutro100,
      surfaceContainerHighest: SereniaColors.neutro200,
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    fontFamily: SereniaTypography.fontFamily,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: SereniaColors.teal700,
      selectionColor: SereniaColors.teal100,
      selectionHandleColor: SereniaColors.teal700,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: SereniaColors.neutro800,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(SereniaRadius.md)),
      ),
    ),
  );
}
