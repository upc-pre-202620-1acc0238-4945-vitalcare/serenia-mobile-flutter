import 'package:flutter/material.dart';
import 'package:serenia_app/core/authorized_image.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/member_radio_tile.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_date_format.dart';
import 'package:serenia_app/features/carecircle/presentation/reassign_care_shift_view_model.dart';

class ReassignCareShiftPage extends StatelessWidget {
  final ReassignCareShiftViewModel _viewModel;

  const new({super.key, required this._viewModel});

  String _subtitle() {
    final CareShift? shift = _viewModel.shift;
    if (shift == null) return '';
    final String day = CircleDateFormat.dayLabel(shift.date, DateTime.now());
    return '$day. Le avisaremos para que sepa que ahora le toca.';
  }

  Future<void> _reassign(BuildContext context, CircleMember member) async {
    final bool done = await _viewModel.reassign();
    if (done && context.mounted) {
      Navigator.pop(context, member.firstName);
    }
  }

  Widget _candidate(CircleMember member) {
    return MemberRadioTile(
      avatar: SereniaAvatar(
        name: member.name,
        photo: AuthorizedImage.provider(member.photoUrl, _viewModel.token),
        size: SereniaSizes.avatarSmall,
      ),
      name: member.firstName,
      relation: Relationship.display(member.relationship),
      selected: member.userId == _viewModel.selectedUserId,
      onTap: () => _viewModel.select(member.userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            final CircleMember? selected = _viewModel.selected;
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SereniaSpacing.screen,
                      SereniaSpacing.sm,
                      SereniaSpacing.screen,
                      SereniaSpacing.cardInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: SereniaSpacing.gap,
                      children: [
                        const BackLink(parent: 'Turnos'),
                        ScreenHeader(
                          title: '¿A quién le pasas el turno?',
                          subtitle: _subtitle(),
                        ),
                        if (_viewModel.errorMessage != null)
                          AlertBanner(_viewModel.errorMessage!),
                        if (_viewModel.candidates.isEmpty)
                          Text(
                            'Aún no hay otros familiares en el círculo.',
                            style: SereniaTypography.cardBody.copyWith(
                              color: SereniaColors.neutro700,
                            ),
                          )
                        else
                          Semantics(
                            label: 'Familiar',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: SereniaSpacing.sm,
                              children: [
                                for (final CircleMember member
                                    in _viewModel.candidates)
                                  _candidate(member),
                              ],
                            ),
                          ),
                        const Spacer(),
                        PrimaryButton(
                          label: selected == null
                              ? 'Pasarle el turno'
                              : 'Pasarle el turno a ${selected.firstName}',
                          loading: _viewModel.isLoading,
                          onPressed: selected == null
                              ? null
                              : () => _reassign(context, selected),
                        ),
                        AffectiveButton(
                          label: 'Cancelar',
                          onPressed: _viewModel.isLoading
                              ? null
                              : () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
