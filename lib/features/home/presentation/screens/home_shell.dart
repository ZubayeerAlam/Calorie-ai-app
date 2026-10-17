import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../food_scan/presentation/screens/food_scan_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../providers/navigation_provider.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _pages = [DashboardScreen(), FoodScanScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();
    return Scaffold(
      body: IndexedStack(index: nav.index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.index,
        onDestinationSelected: nav.setIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
