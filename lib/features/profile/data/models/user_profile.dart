enum Gender { male, female, other }

enum GoalType { lose, maintain, gain }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

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
}
