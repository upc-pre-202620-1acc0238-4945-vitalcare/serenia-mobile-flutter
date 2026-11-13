import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/field_error.dart';

class InviteCodeField extends StatelessWidget {
  final TextEditingController _controller;
  final String? _error;
  final ValueChanged<String>? _onChanged;
  final ValueChanged<String>? _onSubmitted;

  const new({
    super.key,
    required this._controller,
    this._error,
    this._onChanged,
    this._onSubmitted,
  });

  static const int length = 8;

  static String format(String text) {
    final String code = text
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
        .toUpperCase();
    final String limited = code.length > length
        ? code.substring(0, length)
        : code;
    return limited.length > 4
        ? '${limited.substring(0, 4)} ${limited.substring(4)}'
        : limited;
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(SereniaRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Future<void> _paste() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    final String? text = data?.text;
    if (text == null) return;
    final String formatted = format(text);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _onChanged?.call(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _error != null;
    const TextStyle codeStyle = TextStyle(
      color: SereniaColors.teal800,
      fontSize: 30,
      height: 36 / 30,
      fontWeight: FontWeight.w800,
      letterSpacing: 3.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: SereniaSpacing.sm,
      children: [
        const Text(
          'Código de invitación',
          style: TextStyle(
            color: SereniaColors.text,
            fontSize: 16,
            height: 22 / 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.visiblePassword,
          textCapitalization: TextCapitalization.characters,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.oneTimeCode],
          textInputAction: TextInputAction.done,
          inputFormatters: [_InviteCodeFormatter()],
          onChanged: _onChanged,
          onSubmitted: _onSubmitted,
          style: codeStyle,
          decoration: InputDecoration(
            filled: true,
            fillColor: SereniaColors.surface,
            hintText: 'XXXX XXXX',
            hintStyle: codeStyle.copyWith(color: SereniaColors.neutro400),
            constraints: const BoxConstraints(minHeight: 72),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SereniaSpacing.md,
              vertical: 18,
            ),
            enabledBorder: hasError
                ? _border(SereniaColors.error, 3)
                : _border(SereniaColors.borderControl, 2),
            focusedBorder: hasError
                ? _border(SereniaColors.error, 3)
                : _border(SereniaColors.primary, 3),
          ),
        ),
        if (hasError)
          FieldError(_error)
        else
          const Text(
            'Mayúsculas o minúsculas, da igual.',
            style: TextStyle(
              color: SereniaColors.neutro700,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        Center(
          child: OutlinedButton.icon(
            onPressed: _paste,
            icon: const Icon(Icons.content_paste_rounded, size: 20),
            label: const Text('Pegar código'),
            style: OutlinedButton.styleFrom(
              foregroundColor: SereniaColors.primary,
              backgroundColor: SereniaColors.surface,
              minimumSize: const Size(0, SereniaTouch.min),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              side: const BorderSide(color: SereniaColors.primary, width: 2),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                height: 20 / 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InviteCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String formatted = InviteCodeField.format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
