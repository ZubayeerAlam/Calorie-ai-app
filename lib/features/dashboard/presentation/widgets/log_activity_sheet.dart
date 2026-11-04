import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../l10n/l10n.dart';

/// Bottom sheet for entering the activity calories burned on [date].
/// Resolves to the entered kcal, or null if dismissed.
class LogActivitySheet extends StatefulWidget {
  const LogActivitySheet({
    super.key,
    required this.date,
    required this.initialKcal,
    this.importedKcal = 0,
  });

  final DateTime date;
  final int initialKcal;

  /// Workout kcal imported from Health that day, added on top.
  final int importedKcal;

  static Future<int?> show(
    BuildContext context, {
    required DateTime date,
    required int initialKcal,
    int importedKcal = 0,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => LogActivitySheet(
        date: date,
        initialKcal: initialKcal,
        importedKcal: importedKcal,
      ),
    );
  }

  @override
  State<LogActivitySheet> createState() => _LogActivitySheetState();
}

class _LogActivitySheetState extends State<LogActivitySheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialKcal > 0 ? '${widget.initialKcal}' : '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => context.pop(int.tryParse(_controller.text) ?? 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.logActivity,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.activitySheetSubtitle(AppDates.dayLabel(widget.date)),
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          if (widget.importedKcal > 0) ...[
            const SizedBox(height: 4),
            Text(
              l10n.plusHealthWorkouts('${widget.importedKcal}'),
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              hintText: '0',
              suffixText: l10n.unitKcal,
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                l10n.save,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
