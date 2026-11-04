import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// Shown while the stand-in analysis service is in use, so sample results
/// are never mistaken for a real analysis of the photo.
class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key, this.forPhoto = true});

  /// Photo results are sample meals; text results are sample numbers.
  final bool forPhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: Color(0xFF8A6D00)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              forPhoto ? l10n.demoPhoto : l10n.demoText,
              // On the light yellow box: dark in both modes.
              style: TextStyle(fontSize: 13, color: AppColors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
