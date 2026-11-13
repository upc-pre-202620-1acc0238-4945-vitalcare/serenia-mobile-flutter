import 'package:flutter/material.dart';
import 'package:serenia_app/core/authorized_image.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/load_error.dart';
import 'package:serenia_app/core/widgets/member_tile.dart';
import 'package:serenia_app/core/widgets/nav_card.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/section_label.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_view_model.dart';

class CircleMembersPage extends StatelessWidget {
  final CircleViewModel _viewModel;

  const new({super.key, required this._viewModel});

  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    SereniaSpacing.screen,
    SereniaSpacing.screen,
    SereniaSpacing.screen,
    SereniaSpacing.gap,
  );

  Widget _member(CircleMember member) {
    return MemberTile(
      avatar: SereniaAvatar(
        name: member.name,
        photo: AuthorizedImage.provider(member.photoUrl, _viewModel.token),
        tone: member.isMe ? AvatarTone.me : AvatarTone.other,
        size: SereniaSizes.avatar,
      ),
      name: member.firstName,
      relation: Relationship.display(member.relationship),
      isMe: member.isMe,
    );
  }

  Widget _withoutCircle() {
    return ListView(
      padding: _padding,
      children: [
        const ScreenHeader(title: 'Círculo'),
        if (_viewModel.isLoading)
          const Padding(
            padding: EdgeInsets.all(SereniaSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          LoadError(
            message: _viewModel.errorMessage ?? CircleViewModel.noLink,
            onRetry: _viewModel.load,
          ),
      ],
    );
  }

  Widget _circle() {
    return RefreshIndicator(
      onRefresh: () => _viewModel.load(refresh: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: _padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: SereniaSpacing.gap,
                children: [
                  ScreenHeader(
                    title: _viewModel.title,
                    subtitle: _viewModel.subtitle,
                  ),
                  for (final CircleMember member in _viewModel.members)
                    _member(member),
                  const Padding(
                    padding: EdgeInsets.only(top: SereniaSpacing.sectionTop),
                    child: SectionLabel('Organizarse'),
                  ),
                  NavCard(
                    icon: Icons.calendar_today_outlined,
                    tint: SereniaColors.teal100,
                    iconColor: SereniaColors.teal800,
                    title: 'Turnos de atención',
                    subtitle: _viewModel.shiftSummary,
                    onTap: () {},
                  ),
                  NavCard(
                    icon: Icons.article_outlined,
                    tint: SereniaColors.durazno200,
                    iconColor: SereniaColors.durazno900,
                    title: 'Notas compartidas',
                    subtitle: _viewModel.notesSummary,
                    onTap: () {},
                  ),
                  const Spacer(),
                  Center(
                    child: DiscreetLink(
                      label: _viewModel.revokeLabel,
                      icon: Icons.link_off_rounded,
                      onPressed: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return _viewModel.circle == null ? _withoutCircle() : _circle();
          },
        ),
      ),
    );
  }
}
