import 'package:flutter/material.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';

enum SereniaTab {
  home('Inicio', Icons.home_outlined),
  alerts('Alertas', Icons.notifications_none_rounded),
  circle('Círculo', Icons.people_outline_rounded),
  messages('Mensajes', Icons.chat_bubble_outline_rounded),
  account('Cuenta', Icons.person_outline_rounded);

  final String label;
  final IconData icon;

  const SereniaTab(this.label, this.icon);
}

class SereniaNavigationBar extends StatelessWidget {
  final SereniaTab _current;
  final int _pendingAlerts;
  final ValueChanged<SereniaTab> _onSelect;

  const new({
    super.key,
    required this._current,
    required this._pendingAlerts,
    required this._onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SereniaColors.surface,
        border: Border(top: BorderSide(color: SereniaColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
          child: Row(
            spacing: 2,
            children: [
              for (final tab in SereniaTab.values) Expanded(child: _item(tab)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(SereniaTab tab) {
    final bool active = tab == _current;
    final Color color = active
        ? SereniaColors.primary
        : SereniaColors.textSecondary;
    final bool showBadge = tab == SereniaTab.alerts && _pendingAlerts > 0;
    final String semanticsLabel = showBadge
        ? '${tab.label}, $_pendingAlerts '
              '${_pendingAlerts == 1 ? 'pendiente' : 'pendientes'}'
        : tab.label;

    final Widget icon = Icon(tab.icon, color: color, size: 26);

    return Semantics(
      button: true,
      selected: active,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        color: active ? SereniaColors.teal50 : Colors.transparent,
        borderRadius: BorderRadius.circular(SereniaRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onSelect(tab),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SereniaTouch.navigationItem,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                showBadge
                    ? Badge(
                        label: Text('$_pendingAlerts'),
                        backgroundColor: SereniaColors.error,
                        textColor: SereniaColors.neutro50,
                        child: icon,
                      )
                    : icon,
                Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    height: 16 / 13,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
