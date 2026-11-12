import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/workout_plan_request.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';

UserProfile testProfile({
  GoalType goal = GoalType.lose,
  ActivityLevel activity = ActivityLevel.light,
  List<GoalFocus> focuses = const [],
  double weightKg = 72,
}) => UserProfile(
  name: 'Sam',
  gender: Gender.male,
  birthday: DateTime(1995, 5, 10),
  heightCm: 175,
  weightKg: weightKg,
  goal: goal,
  activityLevel: activity,
  dietType: DietType.classic,
  focuses: focuses,
);

WorkoutPlanRequest testRequest({
  UserProfile? profile,
  WorkoutEnvironment environment = WorkoutEnvironment.home,
  FitnessLevel level = FitnessLevel.beginner,
  int minutes = 30,
  Set<HomeEquipment> equipment = const {},
  Set<BodyLimitation> limitations = const {},
}) => WorkoutPlanRequest(
  profile: profile ?? testProfile(),
  settings: ExerciseSettings(
    environment: environment,
    level: level,
    sessionMinutes: minutes,
    homeEquipment: equipment,
    limitations: limitations,
  ),
  now: DateTime(2026, 11, 12, 9),
);
