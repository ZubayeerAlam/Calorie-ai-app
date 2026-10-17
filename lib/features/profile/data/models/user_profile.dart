enum Gender { male, female, other }

enum GoalType { lose, maintain, gain }

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
  });

  final String name;
  final Gender gender;
  final DateTime birthday;
  final int heightCm;
  final double weightKg;
  final GoalType goal;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final bool useMetric;

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
  );
}
