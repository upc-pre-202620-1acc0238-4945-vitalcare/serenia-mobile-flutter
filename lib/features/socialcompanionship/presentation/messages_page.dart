import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';

class MessagesPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SereniaSpacing.screen,
            SereniaSpacing.screen,
            SereniaSpacing.screen,
            12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ScreenHeader(title: 'Mensajes')],
          ),
        ),
      ),
    );
  }
}
