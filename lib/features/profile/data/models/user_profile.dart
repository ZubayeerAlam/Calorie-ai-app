enum Gender { male, female, other }

/// The weight goal. This is the one that sets the calorie target.
enum GoalType { lose, maintain, gain }

/// Extra goals the user can combine with a weight goal. They are saved and
/// shown, but don't change the calorie target.
enum GoalFocus { gainMuscle, boostEnergy, improveNutrition }

enum ActivityLevel { sedentary, light, moderate, active }

enum DietType { classic, vegetarian, vegan, pescatarian, keto }

class UserProfile {
  const UserProfile({
    required this.name,
    required this.gender,
    required this.birthday,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
    required this.activityLevel,
    required this.dietType,
    this.useMetric = true,
    this.dinnerHour = defaultDinnerHour,
    this.dinnerMinute = defaultDinnerMinute,
    this.focuses = const [],
  });

  static const int defaultDinnerHour = 20;
  static const int defaultDinnerMinute = 30;

  final String name;
  final Gender gender;
  final DateTime birthday;
  final int heightCm;
  final double weightKg;
  final GoalType goal;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final bool useMetric;

  /// Usual dinner time (24-hour clock), e.g. for dinner reminders.
  final int dinnerHour;
  final int dinnerMinute;

  /// Extra goals picked in onboarding (in selection order).
  final List<GoalFocus> focuses;

  int get age => ageOn(DateTime.now());

  int ageOn(DateTime date) {
    var years = date.year - birthday.year;
    final hadBirthday =
        date.month > birthday.month ||
        (date.month == birthday.month && date.day >= birthday.day);
    if (!hadBirthday) years--;
    return years;
  }

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender.name,
    'birthday': birthday.toIso8601String(),
    'heightCm': heightCm,
    'weightKg': weightKg,
    'goal': goal.name,
    'activityLevel': activityLevel.name,
    'dietType': dietType.name,
    'useMetric': useMetric,
    'dinnerHour': dinnerHour,
    'dinnerMinute': dinnerMinute,
    'focuses': [for (final f in focuses) f.name],
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String,
    gender: Gender.values.byName(json['gender'] as String),
    birthday: DateTime.parse(json['birthday'] as String),
    heightCm: json['heightCm'] as int,
    weightKg: (json['weightKg'] as num).toDouble(),
    goal: GoalType.values.byName(json['goal'] as String),
    activityLevel: ActivityLevel.values.byName(json['activityLevel'] as String),
    dietType: DietType.values.byName(json['dietType'] as String),
    useMetric: json['useMetric'] as bool? ?? true,
    // Profiles saved before dinner time existed fall back to the default.
    dinnerHour: json['dinnerHour'] as int? ?? defaultDinnerHour,
    dinnerMinute: json['dinnerMinute'] as int? ?? defaultDinnerMinute,
    // Older profiles have no focuses; unknown names are ignored.
    focuses: [
      for (final name in (json['focuses'] as List?) ?? const [])
        ?GoalFocus.values.asNameMap()[name],
    ],
  );
}
