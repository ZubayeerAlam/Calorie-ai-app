import 'package:flutter/material.dart';

import 'empty_state.dart';

/// Placeholder for tabs that aren't built yet.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyState(icon: icon, message: '$title is coming soon'),
    );
  }
}
