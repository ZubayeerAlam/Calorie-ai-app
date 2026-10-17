import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../providers/food_scan_provider.dart';

class FoodScanScreen extends StatelessWidget {
  const FoodScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<FoodScanProvider>();
    final image = scan.image;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Food')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: _buildPreview(context, scan, image?.path)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: scan.status == ScanStatus.picking
                        ? null
                        : scan.captureFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: scan.status == ScanStatus.picking
                        ? null
                        : scan.pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            if (image != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () async {
                    await context.push(
                      AppRoutes.addFoodLocation(imagePath: image.path),
                    );
                    scan.clear();
                  },
                  child: const Text('Log this meal'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(
    BuildContext context,
    FoodScanProvider scan,
    String? path,
  ) {
    switch (scan.status) {
      case ScanStatus.picking:
        return const Center(child: CircularProgressIndicator());
      case ScanStatus.permissionDenied:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Camera permission is required to scan food.'),
              if (scan.permanentlyDenied)
                TextButton(
                  onPressed: scan.openSettings,
                  child: const Text('Open Settings'),
                ),
            ],
          ),
        );
      case ScanStatus.error:
        return const EmptyState(
          icon: Icons.error_outline,
          message: 'Could not load the image. Please try again.',
        );
      case ScanStatus.idle:
      case ScanStatus.picked:
        if (path == null) {
          return const EmptyState(
            icon: Icons.fastfood_outlined,
            message: 'Take or choose a photo of your meal',
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
    }
  }
}
