import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/features/account/presentation/account_page.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alerts_page.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alerts_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_members_page.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_view_model.dart';
import 'package:serenia_app/features/home/presentation/home_page.dart';
import 'package:serenia_app/features/main/serenia_navigation_bar.dart';
import 'package:serenia_app/features/socialcompanionship/presentation/messages_page.dart';

class MainPage extends StatefulWidget {
  const new({super.key});

  static void showTab(BuildContext context, SereniaTab tab) {
    context.findAncestorStateOfType<_MainPageState>()?._select(tab);
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SereniaTab _current = SereniaTab.home;

  late final AlertsViewModel _alertsViewModel;

  final Map<SereniaTab, GlobalKey<NavigatorState>> _navigatorKeys = {
    for (final tab in SereniaTab.values) tab: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    _alertsViewModel = getIt<AlertsViewModel>()..load();
  }

  @override
  void dispose() {
    _alertsViewModel.close();
    super.dispose();
  }

  Widget _rootPage(SereniaTab tab) {
    return switch (tab) {
      SereniaTab.home => const HomePage(),
      SereniaTab.alerts => AlertsPage(viewModel: _alertsViewModel),
      SereniaTab.circle => CircleMembersPage(
        viewModel: getIt<CircleViewModel>()..load(),
      ),
      SereniaTab.messages => const MessagesPage(),
      SereniaTab.account => const AccountPage(),
    };
  }

  void _select(SereniaTab tab) {
    if (tab == _current) {
      _navigatorKeys[tab]!.currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _current = tab);
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (_) =>
          _navigatorKeys[_current]!.currentState?.maybePop(),
      child: Scaffold(
        body: IndexedStack(
          index: _current.index,
          children: [
            for (final tab in SereniaTab.values)
              Navigator(
                key: _navigatorKeys[tab],
                onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (context) => _rootPage(tab),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<AlertsViewModel, AlertsState>(
          bloc: _alertsViewModel,
          buildWhen: (previous, current) =>
              previous.openCount != current.openCount,
          builder: (context, state) => SereniaNavigationBar(
            current: _current,
            pendingAlerts: state.openCount,
            onSelect: _select,
          ),
        ),
      ),
    );
  }
}
