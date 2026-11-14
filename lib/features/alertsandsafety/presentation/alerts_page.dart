import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/empty_state.dart';
import 'package:serenia_app/core/widgets/load_error.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/section_label.dart';
import 'package:serenia_app/core/widgets/serenia_snack_bar.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_card.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_detail_page.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_detail_view_model.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_people.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alerts_view_model.dart';

class AlertsPage extends StatelessWidget {
  final AlertsViewModel _viewModel;

  const new({super.key, required this._viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _viewModel, child: const _AlertsView());
  }
}

class _AlertsView extends StatelessWidget {
  const new();

  static const String outdatedMessage =
      'Esta alerta ya cambió. La actualizamos para ti.';

  Future<void> _openDetail(
    BuildContext context,
    CareAlert alert,
    AlertPeople people,
  ) async {
    final AlertsViewModel viewModel = context.read<AlertsViewModel>();
    final AlertDetailResult? result = await Navigator.push<AlertDetailResult>(
      context,
      MaterialPageRoute(
        builder: (context) => AlertDetailPage(alert: alert, people: people),
      ),
    );
    await viewModel.load();
    switch (result) {
      case AlertDetailResult.resolved:
        viewModel.showMessage(people.resolvedMessage);
      case AlertDetailResult.outdated:
        viewModel.showMessage(outdatedMessage);
      case null:
        break;
    }
  }

  List<Widget> _section(
    BuildContext context,
    String label,
    List<CareAlert> alerts,
    AlertPeople people,
  ) {
    if (alerts.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2),
        child: SectionLabel(label),
      ),
      for (final CareAlert alert in alerts)
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AlertCard(
            alert: alert,
            people: people,
            onTap: () => _openDetail(context, alert, people),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AlertsViewModel viewModel = context.read<AlertsViewModel>();

    return BlocConsumer<AlertsViewModel, AlertsState>(
      listener: (context, state) {
        if (state.message != null) {
          showSereniaSnackBar(context, state.message!);
          viewModel.clearMessage();
        }
      },
      builder: (context, state) {
        final AlertPeople? people = state.people;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SereniaSpacing.screen,
                SereniaSpacing.screen,
                SereniaSpacing.screen,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  ScreenHeader(
                    title: people == null
                        ? 'Alertas'
                        : 'Alertas de ${people.olderAdultFirstName}',
                  ),
                  Expanded(child: _content(context, state, viewModel)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _content(
    BuildContext context,
    AlertsState state,
    AlertsViewModel viewModel,
  ) {
    final AlertPeople? people = state.people;
    if (people == null) {
      if (state.loadError != null) {
        return SingleChildScrollView(
          child: LoadError(message: state.loadError!, onRetry: viewModel.load),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: state.alerts.isEmpty
          ? _empty(people)
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                ..._section(context, 'Pendientes', state.open, people),
                ..._section(context, 'Anteriores', state.previous, people),
              ],
            ),
    );
  }

  Widget _empty(AlertPeople people) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: EmptyState(
            icon: Icons.check_rounded,
            tint: SereniaColors.verde100,
            iconColor: SereniaColors.verde700,
            title: 'Todo en calma',
            body:
                '${people.olderAdultFirstName} no tiene alertas. Te avisaremos '
                'solo si algo se sale de lo habitual.',
          ),
        ),
      ),
    );
  }
}
