import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_card.dart';
import 'package:serenia_app/core/widgets/status_chip.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_detail_view_model.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_people.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_presentation.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_timeline.dart';

class AlertDetailPage extends StatelessWidget {
  final CareAlert _alert;
  final AlertPeople _people;

  const new({super.key, required this._alert, required this._people});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AlertDetailViewModel>(param1: _alert),
      child: _AlertDetailView(people: _people),
    );
  }
}

class _AlertDetailView extends StatelessWidget {
  final AlertPeople _people;

  const new({required this._people});

  @override
  Widget build(BuildContext context) {
    final AlertDetailViewModel viewModel = context.read<AlertDetailViewModel>();

    return BlocConsumer<AlertDetailViewModel, AlertDetailState>(
      listener: (context, state) {
        if (state.result != null) {
          Navigator.pop(context, state.result);
        }
      },
      builder: (context, state) {
        final CareAlert alert = state.alert;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SereniaSpacing.screen,
                SereniaSpacing.sm,
                SereniaSpacing.screen,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BackLink(parent: 'Alertas'),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: SereniaSpacing.sm),
                      children: [
                        _Header(alert: alert, people: _people),
                        const SizedBox(height: 14),
                        SereniaCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 14,
                            children: [
                              Semantics(
                                header: true,
                                child: const Text(
                                  'Qué pasó',
                                  style: TextStyle(
                                    color: SereniaColors.text,
                                    fontSize: 18,
                                    height: 24 / 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              AlertTimeline(steps: alert.timeline(_people)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SereniaSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      if (state.error != null) AlertBanner(state.error!),
                      if (alert.status.isPending) ...[
                        StrongOutlineButton(
                          label: 'Yo me encargo',
                          onPressed: state.acting
                              ? null
                              : viewModel.acknowledge,
                        ),
                        const Text(
                          'Así tus demás familiares sabrán que ya estás en eso.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: SereniaColors.neutro700,
                            fontSize: 15,
                            height: 20 / 15,
                          ),
                        ),
                      ],
                      if (alert.status.isAcknowledged)
                        PrimaryButton(
                          label: 'Ya está bien: marcar como resuelta',
                          icon: Icons.check_rounded,
                          loading: state.acting,
                          onPressed: viewModel.resolve,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final CareAlert _alert;
  final AlertPeople _people;

  const new({required this._alert, required this._people});

  @override
  Widget build(BuildContext context) {
    final bool emergency = _alert.isEmergency;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: emergency ? SereniaColors.errorBg : SereniaColors.warningBg,
        borderRadius: BorderRadius.circular(SereniaRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              StatusChip(label: _alert.typeLabel, tone: _alert.typeTone),
              StatusChip(label: _alert.statusLabel, tone: _alert.statusTone),
            ],
          ),
          Semantics(
            header: true,
            child: Text(
              _alert.title(_people),
              style: const TextStyle(
                color: SereniaColors.text,
                fontSize: 26,
                height: 32 / 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            _alert.description(DateTime.now()),
            style: const TextStyle(
              color: SereniaColors.neutro700,
              fontSize: 17,
              height: 26 / 17,
            ),
          ),
        ],
      ),
    );
  }
}
