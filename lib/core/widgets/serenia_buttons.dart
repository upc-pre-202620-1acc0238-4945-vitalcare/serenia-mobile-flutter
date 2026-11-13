import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

class _PillButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final IconData? _icon;
  final Color _background;
  final Color _foreground;
  final Color? _borderColor;
  final List<BoxShadow> _shadow;
  final double _minHeight;
  final double _fontSize;
  final bool _loading;

  const new({
    required this._label,
    required this._onPressed,
    required this._background,
    required this._foreground,
    this._icon,
    this._borderColor,
    this._shadow = const [],
    this._minHeight = SereniaTouch.button,
    this._fontSize = 16,
    this._loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = _onPressed != null && !_loading;
    final StadiumBorder shape = StadiumBorder(
      side: _borderColor == null
          ? BorderSide.none
          : BorderSide(color: _borderColor, width: 2),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: _onPressed == null ? 0.5 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SereniaRadius.pill),
            boxShadow: enabled ? _shadow : const [],
          ),
          child: Material(
            color: _background,
            shape: shape,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? _onPressed : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: _minHeight,
                  minWidth: double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SereniaSpacing.md,
                    vertical: SereniaSpacing.sm,
                  ),
                  child: Center(
                    child: _loading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: _foreground,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: SereniaSpacing.sm,
                            children: [
                              if (_icon != null)
                                Icon(_icon, color: _foreground, size: 22),
                              Flexible(
                                child: Text(
                                  _label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _foreground,
                                    fontSize: _fontSize,
                                    height: 20 / 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final IconData? _icon;
  final bool _large;
  final bool _loading;

  const new({
    super.key,
    required this._label,
    required this._onPressed,
    this._icon,
    this._large = false,
    this._loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      label: _label,
      onPressed: _onPressed,
      icon: _icon,
      background: SereniaColors.primary,
      foreground: SereniaColors.onPrimary,
      shadow: SereniaShadows.md,
      minHeight: _large ? SereniaTouch.accessButton : SereniaTouch.button,
      fontSize: _large ? 18 : 16,
      loading: _loading,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final IconData? _icon;

  const new({
    super.key,
    required this._label,
    required this._onPressed,
    this._icon,
  });

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      label: _label,
      onPressed: _onPressed,
      icon: _icon,
      background: SereniaColors.surface,
      foreground: SereniaColors.primary,
      borderColor: SereniaColors.primary,
    );
  }
}

class AffectiveButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final IconData? _icon;

  const new({
    super.key,
    required this._label,
    required this._onPressed,
    this._icon,
  });

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      label: _label,
      onPressed: _onPressed,
      icon: _icon,
      background: SereniaColors.surface,
      foreground: SereniaColors.durazno800,
      borderColor: SereniaColors.durazno700,
    );
  }
}

class EmergencyButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;

  const new({super.key, required this._label, required this._onPressed});

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      label: _label,
      onPressed: _onPressed,
      icon: Icons.phone_rounded,
      background: SereniaColors.error,
      foreground: SereniaColors.neutro50,
      shadow: SereniaShadows.md,
    );
  }
}

class StrongOutlineButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;

  const new({super.key, required this._label, required this._onPressed});

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      label: _label,
      onPressed: _onPressed,
      background: SereniaColors.surface,
      foreground: SereniaColors.neutro900,
      borderColor: SereniaColors.neutro800,
    );
  }
}

class QuietButton extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final IconData? _icon;

  const new({
    super.key,
    required this._label,
    required this._onPressed,
    this._icon,
  });

  @override
  Widget build(BuildContext context) {
    return _PillButton(
      label: _label,
      onPressed: _onPressed,
      icon: _icon,
      background: Colors.transparent,
      foreground: SereniaColors.neutro700,
      borderColor: SereniaColors.neutro400,
    );
  }
}

class _TextLink extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final TextStyle _style;
  final IconData? _leadingIcon;
  final IconData? _trailingIcon;

  const new({
    required this._label,
    required this._onPressed,
    required this._style,
    this._leadingIcon,
    this._trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color? color = _style.color;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: _onPressed,
        borderRadius: BorderRadius.circular(SereniaRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SereniaTouch.min),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SereniaSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: SereniaSpacing.xs,
              children: [
                if (_leadingIcon != null)
                  Icon(_leadingIcon, color: color, size: 20),
                Flexible(child: Text(_label, style: _style)),
                if (_trailingIcon != null)
                  Icon(_trailingIcon, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionLink extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final bool _showChevron;

  const new({
    super.key,
    required this._label,
    required this._onPressed,
    this._showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return _TextLink(
      label: _label,
      onPressed: _onPressed,
      trailingIcon: _showChevron ? Icons.chevron_right_rounded : null,
      style: const TextStyle(
        color: SereniaColors.primary,
        fontSize: 15,
        height: 20 / 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class DiscreetLink extends StatelessWidget {
  final String _label;
  final VoidCallback? _onPressed;
  final IconData? _icon;

  const new({
    super.key,
    required this._label,
    required this._onPressed,
    this._icon,
  });

  @override
  Widget build(BuildContext context) {
    return _TextLink(
      label: _label,
      onPressed: _onPressed,
      leadingIcon: _icon,
      style: const TextStyle(
        color: SereniaColors.neutro700,
        fontSize: 15,
        height: 20 / 15,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.underline,
        decorationColor: SereniaColors.neutro700,
      ),
    );
  }
}
