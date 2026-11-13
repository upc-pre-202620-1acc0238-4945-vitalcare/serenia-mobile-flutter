import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/features/iam/presentation/role_card.dart';
import 'package:serenia_app/features/iam/presentation/sign_up_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = SereniaTypography.mayor;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const BackLink(mayor: true),
                  Semantics(
                    header: true,
                    child: Text(
                      '¿Quién eres?',
                      style: textTheme.displaySmall?.copyWith(
                        color: SereniaColors.title,
                      ),
                    ),
                  ),
                  Text(
                    'Así preparamos Serenia a tu medida.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: SereniaColors.neutro700,
                    ),
                  ),
                ],
              ),
              RoleCard(
                title: 'Soy adulto mayor',
                description: 'Quiero contarle a mi familia cómo estoy.',
                icon: Icons.favorite_border_rounded,
                background: SereniaColors.durazno100,
                border: SereniaColors.durazno200,
                iconBackground: SereniaColors.durazno200,
                iconColor: SereniaColors.durazno900,
                onTap: () {},
              ),
              RoleCard(
                title: 'Soy familiar',
                description: 'Quiero saber cómo está mi mamá, papá o abuelo.',
                icon: Icons.people_outline_rounded,
                background: SereniaColors.verde50,
                border: SereniaColors.verde200,
                iconBackground: SereniaColors.verde200,
                iconColor: SereniaColors.verde900,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
