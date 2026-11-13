import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/day_shift_card.dart';
import 'package:serenia_app/core/widgets/load_error.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/week_strip.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_rules.dart';
import 'package:serenia_app/features/carecircle/presentation/care_shifts_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_date_format.dart';

class CareShiftsPage extends StatelessWidget {
  final CareShiftsViewModel _viewModel;

  const new({super.key, required this._viewModel});

  String _who(CareShift day) {
    if (day.isMine) return 'Tú';
    final String? assigneeId = day.assigneeId;
    return assigneeId == null ? 'Libre' : _viewModel.firstNameOf(assigneeId);
  }

  ShiftDay _shiftDay(CareShift day) {
    final String weekday = CircleDateFormat.weekdayShort(day.date);
    final String who = day.isFree ? 'sin asignar' : _who(day);
    return ShiftDay(
      weekday: weekday,
      number: '${day.date.day}',
      who: _who(day),
      isFree: day.isFree,
      semanticsLabel: '$weekday ${day.date.day}: $who',
    );
  }

  String _joinNames(List<String> names) {
    if (names.length <= 1) return names.join();
    return '${names.sublist(0, names.length - 1).join(', ')} y ${names.last}';
  }

  Widget _dayCard(CareShift day) {
    final bool isToday =
        CircleDateFormat.daysBetween(_viewModel.today, day.date) == 0;
    final String label = CircleDateFormat.dayLabel(day.date, _viewModel.today);
    final String? assigneeId = day.assigneeId;

    if (day.isMine) {
      final List<String> others = _viewModel.otherFirstNames;
      final String when = isToday ? 'hoy' : 'ese día';
      final String verb = others.length == 1 ? 've' : 'ven';
      return DayShiftCard(
        label: label,
        title: 'Te toca a ti',
        body: others.isEmpty
            ? 'Una llamada o un mensaje cuentan.'
            : 'Una llamada o un mensaje cuentan. '
                  '${_joinNames(others)} $verb que $when estás tú.',
      );
    }

    if (assigneeId != null) {
      final String name = _viewModel.firstNameOf(assigneeId);
      if (_viewModel.isConflict(day)) {
        final String weekday = CircleDateFormat.weekdayLong(day.date);
        return DayShiftCard(
          label: label,
          title: 'Acompaña $name',
          error:
              '$name se anotó para este día hace un momento. '
              'El $weekday ya está cubierto.',
          actions: [
            SecondaryButton(
              label: 'Ver otro día libre',
              onPressed: _viewModel.showNextFreeDay,
            ),
          ],
        );
      }
      return DayShiftCard(
        label: label,
        title: 'Acompaña $name',
        body: isToday
            ? 'Hoy no te toca, pero puedes escribirle igual.'
            : 'Ese día no te toca, pero puedes escribirle igual.',
      );
    }

    if (CareShiftRules.isPast(day.date, _viewModel.today)) {
      return DayShiftCard(
        label: label,
        title: 'Sin asignar',
        body: 'Nadie se anotó este día.',
      );
    }

    if (!_viewModel.canAssign(day)) {
      return DayShiftCard(
        label: label,
        title: 'Sin asignar',
        body: CareShiftsViewModel.dateNotAllowed,
      );
    }

    return DayShiftCard(
      label: label,
      title: 'Sin asignar',
      body: 'Nadie se ha anotado para este día.',
      error: _viewModel.assignError,
      actions: [
        PrimaryButton(
          label: 'Me anoto este día',
          loading: _viewModel.isAssigning,
          onPressed: _viewModel.assignSelected,
        ),
      ],
    );
  }

  List<Widget> _week() {
    final CareShift? selected = _viewModel.selectedDay;
    if (_viewModel.errorMessage != null) {
      return [
        LoadError(
          message: _viewModel.errorMessage!,
          onRetry: _viewModel.loadWeek,
        ),
      ];
    }
    if (_viewModel.isLoading || selected == null) {
      return const [
        Padding(
          padding: EdgeInsets.all(SereniaSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    return [
      WeekStrip(
        rangeLabel: CircleDateFormat.weekRange(
          _viewModel.weekStart,
          _viewModel.weekEnd,
        ),
        days: [for (final CareShift day in _viewModel.days) _shiftDay(day)],
        selected: _viewModel.selectedIndex,
        onSelect: _viewModel.selectDay,
        onPrev: _viewModel.previousWeek,
        onNext: _viewModel.canGoNext ? _viewModel.nextWeek : null,
      ),
      _dayCard(selected),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                SereniaSpacing.screen,
                SereniaSpacing.sm,
                SereniaSpacing.screen,
                SereniaSpacing.cardInset,
              ),
              children: [
                const BackLink(parent: 'Círculo'),
                const SizedBox(height: SereniaSpacing.gap),
                ScreenHeader(
                  title: 'Turnos de atención',
                  subtitle:
                      'Quién da seguimiento a ${_viewModel.olderAdultFirstName} '
                      'cada día, para que nadie asuma que otro ya la llamó.',
                ),
                for (final Widget section in _week()) ...[
                  const SizedBox(height: SereniaSpacing.gap),
                  section,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
