import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/features/iam/presentation/role_selection_page.dart';
import 'package:serenia_app/features/iam/presentation/sign_in_page.dart';
import 'package:serenia_app/features/iam/presentation/welcome_illustration.dart';

class WelcomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = SereniaTypography.mayor;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: SereniaColors.teal700,
        body: Stack(
          children: [
            const Positioned(
              left: -150,
              top: 120,
              child: _Circle(size: 360, color: SereniaColors.teal600),
            ),
            const Positioned(
              right: -140,
              bottom: 150,
              child: _Circle(size: 300, color: SereniaColors.teal800),
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 16,
                        children: [
                          const _WelcomeHeader(),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const WelcomeIllustration(),
                              Positioned(
                                right: 16,
                                top: 32,
                                child: _Circle(
                                  size: 18,
                                  color: SereniaColors.durazno300.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 12,
                                top: 8,
                                child: _Circle(
                                  size: 12,
                                  color: SereniaColors.verde300.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Semantics(
                                  header: true,
                                  child: Text(
                                    'Tu familia, más cerca',
                                    style: textTheme.displaySmall?.copyWith(
                                      color: SereniaColors.neutro50,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Respondes con un toque y tu familia sabe cómo estás, sin tener que llamar.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: SereniaColors.teal100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 12,
                            children: [
                              PillButton(
                                label: 'Crear mi cuenta',
                                background: SereniaColors.durazno300,
                                foreground: SereniaColors.teal900,
                                size: ButtonSize.mayor,
                                shadow: const [
                                  BoxShadow(
                                    color: Color(0x590F3B36),
                                    offset: Offset(0, 8),
                                    blurRadius: 20,
                                  ),
                                ],
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RoleSelectionPage(),
                                  ),
                                ),
                              ),
                              PillButton(
                                label: 'Ya tengo cuenta',
                                background: SereniaColors.neutro50,
                                foreground: SereniaColors.teal800,
                                size: ButtonSize.mayor,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInPage(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: SereniaColors.neutro50,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/serenia_isotipo_crema.png',
                width: 34,
                height: 34,
                excludeFromSemantics: true,
              ),
            ),
          ),
          const Text(
            'Serenia',
            style: TextStyle(
              color: SereniaColors.neutro50,
              fontSize: 28,
              height: 34 / 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double _size;
  final Color _color;

  const new({required this._size, required this._color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
    );
  }
}
