import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/field_error.dart';

class SereniaTextField extends StatefulWidget {
  final String _label;
  final TextEditingController? _controller;
  final String? _hint;
  final String? _helper;
  final String? _error;
  final String? _prefixText;
  final bool _isPassword;
  final TextInputType? _keyboardType;
  final TextInputAction? _textInputAction;
  final TextCapitalization _textCapitalization;
  final List<TextInputFormatter>? _inputFormatters;
  final Iterable<String>? _autofillHints;
  final int _maxLines;
  final ValueChanged<String>? _onChanged;
  final ValueChanged<String>? _onSubmitted;
  final bool _invalid;
  final bool _mayor;

  const new({
    super.key,
    required this._label,
    this._controller,
    this._hint,
    this._helper,
    this._error,
    this._prefixText,
    this._isPassword = false,
    this._keyboardType,
    this._textInputAction,
    this._textCapitalization = TextCapitalization.none,
    this._inputFormatters,
    this._autofillHints,
    this._maxLines = 1,
    this._onChanged,
    this._onSubmitted,
    this._invalid = false,
    this._mayor = false,
  });

  @override
  State<SereniaTextField> createState() => _SereniaTextFieldState();
}

class _SereniaTextFieldState extends State<SereniaTextField> {
  bool _obscured = true;

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(SereniaRadius.sm),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget._error != null || widget._invalid;
    final bool mayor = widget._mayor;
    final double labelSize = mayor ? 20 : 16;
    final double labelHeight = mayor ? 26 : 22;
    final double inputSize = mayor ? 20 : 17;
    final double inputHeight = mayor ? 28 : 24;
    final double helperSize = mayor ? 18 : 14;
    final double helperHeight = mayor ? 24 : 20;
    final OutlineInputBorder enabledBorder = hasError
        ? _border(SereniaColors.error, 3)
        : _border(SereniaColors.borderControl, 2);
    final OutlineInputBorder focusedBorder = hasError
        ? _border(SereniaColors.error, 3)
        : _border(SereniaColors.primary, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: mayor ? SereniaSpacing.sm : 6,
      children: [
        Text(
          widget._label,
          style: TextStyle(
            color: SereniaColors.text,
            fontSize: labelSize,
            height: labelHeight / labelSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextField(
          controller: widget._controller,
          obscureText: widget._isPassword && _obscured,
          keyboardType: widget._keyboardType,
          textInputAction: widget._textInputAction,
          textCapitalization: widget._textCapitalization,
          inputFormatters: widget._inputFormatters,
          autofillHints: widget._autofillHints,
          autocorrect: !widget._isPassword,
          enableSuggestions: !widget._isPassword,
          maxLines: widget._isPassword ? 1 : widget._maxLines,
          onChanged: widget._onChanged,
          onSubmitted: widget._onSubmitted,
          style: TextStyle(
            color: SereniaColors.text,
            fontSize: inputSize,
            height: inputHeight / inputSize,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: SereniaColors.surface,
            hintText: widget._hint,
            hintStyle: TextStyle(
              color: SereniaColors.neutro600,
              fontSize: inputSize,
              fontWeight: FontWeight.w600,
            ),
            prefixText: widget._prefixText,
            prefixStyle: TextStyle(
              color: SereniaColors.neutro700,
              fontSize: inputSize,
              fontWeight: FontWeight.w700,
            ),
            constraints: BoxConstraints(minHeight: mayor ? 64 : 56),
            contentPadding: EdgeInsets.symmetric(
              horizontal: mayor ? 18 : SereniaSpacing.md,
              vertical: mayor ? 18 : SereniaSpacing.md,
            ),
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            border: enabledBorder,
            suffixIcon: widget._isPassword
                ? IconButton(
                    tooltip: _obscured
                        ? 'Mostrar contraseña'
                        : 'Ocultar contraseña',
                    color: SereniaColors.neutro700,
                    iconSize: mayor ? 28 : 24,
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                : null,
          ),
        ),
        if (widget._error != null)
          FieldError(widget._error!, mayor: mayor)
        else if (widget._helper != null && !hasError)
          Text(
            widget._helper!,
            style: TextStyle(
              color: SereniaColors.neutro700,
              fontSize: helperSize,
              height: helperHeight / helperSize,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
