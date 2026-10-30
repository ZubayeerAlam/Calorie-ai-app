import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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
              forPhoto
                  ? 'Demo result: AI analysis isn\'t connected yet, so these '
                        'are sample foods, not what\'s in your photo. Edit '
                        'them before saving.'
                  : 'Demo result: AI analysis isn\'t connected yet, so these '
                        'are sample numbers, not real nutrition for what you '
                        'typed. Edit them before saving.',
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
