import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import 'camera_button.dart';

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

/// Bottom bar: green icon + label for the active tab, grey otherwise.
///
/// Home and Tracker on the left, Exercise and Account on the right, and
/// the camera button in the middle. The camera is an action (it opens the
/// Add food chooser), not a tab, so it has no index.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCameraPressed,
  });

  /// The tabs, in branch order (see `createAppRouter`).
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
      label: l10n.tabExercise,
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center_rounded,
    ),
    AppNavItem(
      label: l10n.tabAccount,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  /// Width of the middle slot that holds the camera button.
  static const double cameraSlot = 72;

  /// How many tabs sit to the left of the camera; the rest sit right.
  static const int _tabsOnLeft = 2;

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCameraPressed;

  Widget _tab(int i) => Expanded(
    child: _NavButton(
      item: items[i],
      selected: i == currentIndex,
      onTap: () => onTap(i),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final count = items.length;
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
              for (var i = 0; i < _tabsOnLeft; i++) _tab(i),
              SizedBox(
                width: cameraSlot,
                child: Center(
                  child: CameraButton(
                    key: const ValueKey('camera-button'),
                    onPressed: onCameraPressed,
                  ),
                ),
              ),
              for (var i = _tabsOnLeft; i < count; i++) _tab(i),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
