import 'package:flutter/foundation.dart';

import '../../../core/utils/date_utils.dart';
import '../../profile/providers/profile_provider.dart';
import '../data/models/weight_entry.dart';
import '../data/weight_log_repository.dart';

/// The weight log. The latest weigh-in is also the profile's weight, so
/// logging a new weight recalculates the targets.
class WeightLogProvider extends ChangeNotifier {
  WeightLogProvider(this._repository, this._profile) {
    _profile.addListener(_seedStartingWeight);
    _seedStartingWeight();
  }

  final WeightLogRepository _repository;
  final ProfileProvider _profile;

  /// Every weigh-in, oldest first.
  List<WeightEntry> get entries => _repository.all();

  WeightEntry? get latest {
    final all = entries;
    return all.isEmpty ? null : all.last;
  }

  /// Saves [weightKg] for [date]. When it's the newest weigh-in it also
  /// becomes the profile's weight.
  Future<void> logWeight(DateTime date, double weightKg) async {
    final day = AppDates.dateOnly(date);
    final newest = latest;
    await _repository.set(day, weightKg);
    if (newest == null || !day.isBefore(newest.date)) {
      _profile.updateWeight(weightKg);
    }
    notifyListeners();
  }

  /// Deletes a weigh-in; the profile follows the new newest one.
  Future<void> remove(DateTime date) async {
    await _repository.remove(date);
    final newest = latest;
    if (newest != null) _profile.updateWeight(newest.weightKg);
    notifyListeners();
  }

  /// The onboarding weight is the first point of the trend.
  void _seedStartingWeight() {
    final profile = _profile.profile;
    if (profile == null || entries.isNotEmpty) return;
    _repository.set(AppDates.today(), profile.weightKg);
  }

  /// Re-reads storage, e.g. after cloud data was downloaded.
  void reload() {
    _seedStartingWeight();
    notifyListeners();
  }

  @override
  void dispose() {
    _profile.removeListener(_seedStartingWeight);
    super.dispose();
  }
}
