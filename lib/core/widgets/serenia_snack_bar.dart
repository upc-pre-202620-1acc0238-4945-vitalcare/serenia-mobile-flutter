import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSereniaSnackBar(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final bool hasAction = actionLabel != null && onAction != null;
  messenger.hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      duration: Duration(seconds: hasAction ? 6 : 4),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      elevation: 0,
      content: Row(
        spacing: 12,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: SereniaColors.verde300,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: SereniaColors.verde900,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: SereniaColors.neutro50,
                fontSize: 16,
                height: 22 / 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (hasAction)
            TextButton(
              onPressed: () {
                messenger.hideCurrentSnackBar(
                  reason: SnackBarClosedReason.action,
                );
                onAction();
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(SereniaTouch.min, SereniaTouch.min),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                foregroundColor: SereniaColors.durazno300,
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                  decorationColor: SereniaColors.durazno300,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
