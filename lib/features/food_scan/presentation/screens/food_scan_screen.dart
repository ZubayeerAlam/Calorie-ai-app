import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../providers/food_scan_provider.dart';
import '../../../../l10n/l10n.dart';

class FoodScanScreen extends StatelessWidget {
  const FoodScanScreen({super.key, this.returnPhoto = false});

  /// True when Add Food opened this screen: the photo goes back to it.
  /// Otherwise (opened from the camera chooser) the photo is sent for AI
  /// analysis, replacing this screen.
  final bool returnPhoto;

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<FoodScanProvider>();
    final image = scan.image;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanFood)),
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
                    label: Text(l10n.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: scan.status == ScanStatus.picking
                        ? null
                        : scan.pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: Text(l10n.gallery),
                  ),
                ),
              ],
            ),
            if (image != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    final path = image.path;
                    scan.clear();
                    if (returnPhoto) {
                      context.pop(path);
                    } else {
                      context.pushReplacement(
                        AppRoutes.analyzeFoodLocation(path),
                      );
                    }
                  },
                  child: Text(l10n.useThisPhoto),
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
              Text(l10n.cameraPermissionRequired),
              if (scan.permanentlyDenied)
                TextButton(
                  onPressed: scan.openSettings,
                  child: Text(l10n.openSettings),
                ),
            ],
          ),
        );
      case ScanStatus.error:
        return EmptyState(
          icon: Icons.error_outline,
          message: l10n.imageLoadFailed,
        );
      case ScanStatus.idle:
      case ScanStatus.picked:
        if (path == null) {
          return EmptyState(
            icon: Icons.fastfood_outlined,
            message: l10n.scanWithCameraHint,
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
