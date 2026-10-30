import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/camera_button.dart';

/// Bottom-navigation scaffold around the tab branches of the router:
/// four tabs plus a raised camera button in the middle.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onCameraPressed(BuildContext context) {
    // For now this opens Add Food, which already has "Scan a photo" and the
    // manual form. It will open the camera / manual chooser once that exists.
    context.push(AppRoutes.addFoodLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CameraButton(
        key: const ValueKey('camera-button'),
        onPressed: () => _onCameraPressed(context),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        // Tapping the current tab again returns it to its first page.
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
