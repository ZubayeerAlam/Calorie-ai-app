import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

class AppNavItem {
  const AppNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// White bottom bar: green icon + label for the active tab, grey otherwise.
///
/// Three tabs: Home and Tracker left of an empty middle slot, Account on
/// the right (it takes the whole right half). The
/// camera button that sits in that slot is a floating button added by the
/// scaffold (see `HomeShell`), because a button that rises above the bar
/// must be outside the bar to receive taps.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static List<AppNavItem> get items => [
    AppNavItem(
      label: l10n.tabHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    AppNavItem(
      label: l10n.tabTracker,
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
    ),
    AppNavItem(
      label: l10n.tabAccount,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  /// Width reserved in the middle for the camera button.
  static const double cameraGap = 84;

  /// How many tabs sit to the left of the camera gap; the rest sit right.
  static const int _tabsOnLeft = 2;

  final int currentIndex;
  final ValueChanged<int> onTap;

  Widget _tab(int i) => Expanded(
    child: _NavButton(
      item: items[i],
      selected: i == currentIndex,
      onTap: () => onTap(i),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          // Room for the labels at the largest text size.
          height: 68,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [for (var i = 0; i < _tabsOnLeft; i++) _tab(i)],
                ),
              ),
              const SizedBox(width: cameraGap),
              Expanded(
                child: Row(
                  children: [
                    for (var i = _tabsOnLeft; i < items.length; i++) _tab(i),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The readable green (darker than the brand green on white).
    final color = selected ? AppColors.accent : AppColors.textLight;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? item.activeIcon : item.icon, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
