import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/option_grid.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/step_indicator.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';
import 'package:serenia_app/features/carecircle/presentation/invitation_code_page.dart';

class RelationshipPage extends StatefulWidget {
  const new({super.key});

  @override
  State<RelationshipPage> createState() => _RelationshipPageState();
}

class _RelationshipPageState extends State<RelationshipPage> {
  Relationship? _selected;

  void _continue() {
    final Relationship? relationship = _selected;
    if (relationship == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvitationCodePage(relationship: relationship),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SereniaSpacing.screen,
                  12,
                  SereniaSpacing.screen,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 18,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: SereniaSpacing.sm,
                      children: [
                        if (Navigator.canPop(context)) const BackLink(),
                        const StepIndicator(current: 2),
                        Semantics(
                          header: true,
                          child: Text(
                            '¿Qué es tu familiar para ti?',
                            style: textTheme.displaySmall?.copyWith(
                              color: SereniaColors.title,
                            ),
                          ),
                        ),
                        Text(
                          'Así sabrá quién forma parte de su círculo.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: SereniaColors.neutro700,
                          ),
                        ),
                      ],
                    ),
                    Semantics(
                      label: 'Parentesco con tu familiar',
                      child: OptionGrid<Relationship>(
                        options: [
                          for (final relationship in Relationship.values)
                            (relationship, relationship.label),
                        ],
                        selected: _selected,
                        onSelected: (relationship) =>
                            setState(() => _selected = relationship),
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Continuar',
                      size: ButtonSize.large,
                      onPressed: _selected == null ? null : _continue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
