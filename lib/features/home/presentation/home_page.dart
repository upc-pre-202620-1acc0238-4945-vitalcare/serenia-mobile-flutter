import 'package:flutter/material.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_snack_bar.dart';
import 'package:serenia_app/features/iam/application/sign_out_use_case.dart';
import 'package:serenia_app/features/iam/presentation/welcome_page.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await getIt<SignOutUseCase>().execute();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      showSereniaSnackBar(context, ErrorMessages.from(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SereniaSpacing.screen,
            SereniaSpacing.md,
            SereniaSpacing.screen,
            SereniaSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(title: 'Inicio'),
              const Spacer(),
              QuietButton(
                label: 'Cerrar sesión',
                icon: Icons.logout_rounded,
                onPressed: () => _signOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
