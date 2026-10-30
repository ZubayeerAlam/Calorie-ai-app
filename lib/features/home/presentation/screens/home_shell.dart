import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../food_log/presentation/add_food_method.dart';
import '../../../food_log/presentation/widgets/add_food_chooser_sheet.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/camera_button.dart';

/// Bottom-navigation scaffold around the tab branches of the router:
/// four tabs plus a raised camera button in the middle.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  Future<void> _onCameraPressed(BuildContext context) async {
    final method = await AddFoodChooserSheet.show(context);
    if (method == null || !context.mounted) return;
    switch (method) {
      case AddFoodMethod.camera:
        context.push(AppRoutes.scanLocation());
      case AddFoodMethod.manual:
        context.push(AppRoutes.addManually);
    }
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
