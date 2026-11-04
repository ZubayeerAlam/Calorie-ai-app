import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/health_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';
import '../../providers/activity_log_provider.dart';
import '../../../../l10n/l10n.dart';

/// Connect Apple Health / Health Connect on the Account tab. Hidden where
/// neither exists.
class HealthCard extends StatefulWidget {
  const HealthCard({super.key});

  @override
  State<HealthCard> createState() => _HealthCardState();
}

class _HealthCardState extends State<HealthCard> {
  late Future<HealthAvailability> _availability = context
      .read<ActivityLogProvider>()
      .healthAvailability();
  bool _connecting = false;

  Future<void> _connect(ActivityLogProvider activity) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _connecting = true);
    final allowed = await activity.connectHealth();
    if (!mounted) return;
    setState(() => _connecting = false);
    if (!allowed) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.healthAccessDenied(activity.healthName))),
      );
    }
  }

  Future<void> _install(ActivityLogProvider activity) async {
    await activity.installHealth();
    // Check again when the user comes back from the store.
    if (mounted) {
      setState(() => _availability = activity.healthAvailability());
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = context.watch<ActivityLogProvider>();
    return FutureBuilder(
      future: _availability,
      builder: (context, snapshot) {
        final availability = snapshot.data;
        if (availability == null ||
            availability == HealthAvailability.unsupported) {
          return const SizedBox.shrink();
        }
        final connected = activity.healthConnected;
        final (String text, Widget button) = switch (availability) {
          HealthAvailability.needsInstall => (
            l10n.healthInstall(activity.healthName),
            _button(l10n.install, () => _install(activity)),
          ),
          _ when connected => (
            l10n.healthImporting,
            OutlinedButton(
              key: const ValueKey('disconnect-health'),
              onPressed: activity.disconnectHealth,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textDark,
                shape: const StadiumBorder(),
              ),
              child: Text(l10n.disconnect),
            ),
          ),
          _ => (
            l10n.healthPitch,
            _button(
              _connecting ? l10n.connecting : l10n.connect,
              _connecting ? null : () => _connect(activity),
            ),
          ),
        };

        return DashboardCard(
          child: Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 32,
                color: connected ? AppColors.badge : AppColors.textLight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connected
                          ? l10n.healthConnected(activity.healthName)
                          : activity.healthName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      text,
                      style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 8),
                    button,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _button(String label, VoidCallback? onPressed) =>
      ElevatedButton(
        key: const ValueKey('connect-health'),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(label),
      );
}
