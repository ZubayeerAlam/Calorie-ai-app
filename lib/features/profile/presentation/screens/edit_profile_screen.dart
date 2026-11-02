import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../onboarding/providers/onboarding_provider.dart';
import '../../data/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../profile_labels.dart';
import '../widgets/choice_chips.dart';
import '../widgets/edit_section.dart';
import '../widgets/height_input.dart';
import '../widgets/tap_row.dart';

/// Account → Edit profile: everything from onboarding except the weight,
/// which is logged on Tracker. Saving recalculates the targets unless they
/// were set by hand.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final UserProfile _original = context.read<ProfileProvider>().profile!;
  late final TextEditingController _name = TextEditingController(
    text: _original.name,
  );
  late Gender _gender = _original.gender;
  late DateTime _birthday = _original.birthday;
  late int? _heightCm = _original.heightCm;
  late bool _metric = _original.useMetric;
  late GoalType _goal = _original.goal;
  late Set<GoalFocus> _focuses = _original.focuses.toSet();
  late ActivityLevel _activity = _original.activityLevel;
  late DietType _diet = _original.dietType;
  late TimeOfDay _dinner = TimeOfDay(
    hour: _original.dinnerHour,
    minute: _original.dinnerMinute,
  );

  bool get _canSave => _name.text.trim().isNotEmpty && _heightCm != null;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(now.year - OnboardingProvider.maxAge),
      lastDate: DateTime(
        now.year - OnboardingProvider.minAge,
        now.month,
        now.day,
      ),
      helpText: 'Birthday',
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _pickDinner() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dinner,
      helpText: 'Usual dinner time',
    );
    if (picked != null) setState(() => _dinner = picked);
  }

  void _save() {
    context.read<ProfileProvider>().updateProfile(
      _original.copyWith(
        name: _name.text.trim(),
        gender: _gender,
        birthday: _birthday,
        heightCm: _heightCm,
        useMetric: _metric,
        goal: _goal,
        // Kept in the order they were picked, new ones last.
        focuses: [
          for (final f in _original.focuses)
            if (_focuses.contains(f)) f,
          for (final f in GoalFocus.values)
            if (_focuses.contains(f) && !_original.focuses.contains(f)) f,
        ],
        activityLevel: _activity,
        dietType: _diet,
        dinnerHour: _dinner.hour,
        dinnerMinute: _dinner.minute,
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile saved')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final preview = _original.copyWith(birthday: _birthday, useMetric: _metric);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                EditSection(
                  title: 'Name',
                  child: TextField(
                    key: const ValueKey('edit-name'),
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                EditSection(
                  title: 'Units',
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('kg · cm')),
                      ButtonSegment(value: false, label: Text('lb · ft')),
                    ],
                    selected: {_metric},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) =>
                        setState(() => _metric = s.first),
                    style: SegmentedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      selectedBackgroundColor: AppColors.primary,
                      selectedForegroundColor: AppColors.textDark,
                    ),
                  ),
                ),
                EditSection(
                  title: 'Height',
                  child: HeightInput(
                    initialCm: _original.heightCm,
                    metric: _metric,
                    onChanged: (cm) => setState(() => _heightCm = cm),
                  ),
                ),
                EditSection(
                  title: 'Weight',
                  hint: 'Log a new weight on the Tracker tab.',
                  child: TapRow(
                    icon: Icons.monitor_weight_outlined,
                    value: preview.weightLabel,
                  ),
                ),
                EditSection(
                  title: 'Birthday',
                  hint: 'Age ${preview.age}',
                  child: TapRow(
                    key: const ValueKey('edit-birthday'),
                    icon: Icons.cake_outlined,
                    value:
                        '${_birthday.day}/${_birthday.month}/${_birthday.year}',
                    onTap: _pickBirthday,
                  ),
                ),
                EditSection(
                  title: 'Gender',
                  child: OptionChips(
                    options: Gender.values,
                    selected: {_gender},
                    labelOf: (g) => g.label,
                    onChanged: (s) => setState(() => _gender = s.first),
                  ),
                ),
                EditSection(
                  title: 'Weight goal',
                  hint: 'This sets your calorie target.',
                  child: OptionChips(
                    options: GoalType.values,
                    selected: {_goal},
                    labelOf: (g) => '${g.emoji} ${g.label}',
                    onChanged: (s) => setState(() => _goal = s.first),
                  ),
                ),
                EditSection(
                  title: 'Also focus on',
                  child: OptionChips(
                    options: GoalFocus.values,
                    selected: _focuses,
                    multiple: true,
                    labelOf: (f) => '${f.emoji} ${f.label}',
                    onChanged: (s) => setState(() => _focuses = s),
                  ),
                ),
                EditSection(
                  title: 'Activity level',
                  hint: _activity.description,
                  child: OptionChips(
                    options: ActivityLevel.values,
                    selected: {_activity},
                    labelOf: (a) => a.label,
                    onChanged: (s) => setState(() => _activity = s.first),
                  ),
                ),
                EditSection(
                  title: 'Diet',
                  hint: _diet.description,
                  child: OptionChips(
                    options: DietType.values,
                    selected: {_diet},
                    labelOf: (d) => d.label,
                    onChanged: (s) => setState(() => _diet = s.first),
                  ),
                ),
                EditSection(
                  title: 'Usual dinner time',
                  child: TapRow(
                    key: const ValueKey('edit-dinner'),
                    icon: Icons.schedule_rounded,
                    value: _dinner.format(context),
                    onTap: _pickDinner,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  key: const ValueKey('save-profile'),
                  onPressed: _canSave ? _save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textDark,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.4,
                    ),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
