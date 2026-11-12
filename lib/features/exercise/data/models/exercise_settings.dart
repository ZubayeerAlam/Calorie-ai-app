import '../../../profile/data/models/user_profile.dart';

/// Where the user works out.
enum WorkoutEnvironment { home, gym }

enum FitnessLevel { beginner, intermediate, advanced }

/// Equipment the user has at home (bodyweight needs none).
enum HomeEquipment { dumbbells, bands }

/// Body areas to go easy on; exercises that load them are left out.
enum BodyLimitation { knees, lowerBack, shoulders, wrists }

/// The choices made on the Exercise setup screen.
class ExerciseSettings {
  const ExerciseSettings({
    required this.environment,
    required this.level,
    this.sessionMinutes = defaultSessionMinutes,
    this.homeEquipment = const {},
    this.limitations = const {},
  });

  /// Default settings for [environment], with the level guessed from the
  /// profile's activity level.
  factory ExerciseSettings.defaultsFor(
    WorkoutEnvironment environment,
    ActivityLevel activity,
  ) => ExerciseSettings(environment: environment, level: levelFor(activity));

  static const int defaultSessionMinutes = 30;
  static const List<int> sessionMinuteOptions = [15, 20, 30, 45, 60];

  final WorkoutEnvironment environment;
  final FitnessLevel level;
  final int sessionMinutes;
  final Set<HomeEquipment> homeEquipment;
  final Set<BodyLimitation> limitations;

  static FitnessLevel levelFor(ActivityLevel activity) => switch (activity) {
    ActivityLevel.sedentary || ActivityLevel.light => FitnessLevel.beginner,
    ActivityLevel.moderate => FitnessLevel.intermediate,
    ActivityLevel.active => FitnessLevel.advanced,
  };

  /// Sessions in a week, from the profile's activity level.
  static int sessionsPerWeek(ActivityLevel activity) => switch (activity) {
    ActivityLevel.sedentary => 2,
    ActivityLevel.light => 3,
    ActivityLevel.moderate => 4,
    ActivityLevel.active => 5,
  };

  ExerciseSettings copyWith({
    WorkoutEnvironment? environment,
    FitnessLevel? level,
    int? sessionMinutes,
    Set<HomeEquipment>? homeEquipment,
    Set<BodyLimitation>? limitations,
  }) => ExerciseSettings(
    environment: environment ?? this.environment,
    level: level ?? this.level,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    homeEquipment: homeEquipment ?? this.homeEquipment,
    limitations: limitations ?? this.limitations,
  );

  Map<String, dynamic> toJson() => {
    'environment': environment.name,
    'level': level.name,
    'sessionMinutes': sessionMinutes,
    'homeEquipment': [for (final e in homeEquipment) e.name],
    'limitations': [for (final l in limitations) l.name],
  };

  factory ExerciseSettings.fromJson(Map<String, dynamic> json) =>
      ExerciseSettings(
        environment: WorkoutEnvironment.values.byName(
          json['environment'] as String,
        ),
        level: FitnessLevel.values.byName(json['level'] as String),
        sessionMinutes: json['sessionMinutes'] as int? ?? defaultSessionMinutes,
        // Unknown names (from a newer version) are ignored.
        homeEquipment: {
          for (final name in (json['homeEquipment'] as List?) ?? const [])
            ?HomeEquipment.values.asNameMap()[name],
        },
        limitations: {
          for (final name in (json['limitations'] as List?) ?? const [])
            ?BodyLimitation.values.asNameMap()[name],
        },
      );

  @override
  bool operator ==(Object other) =>
      other is ExerciseSettings &&
      other.environment == environment &&
      other.level == level &&
      other.sessionMinutes == sessionMinutes &&
      other.homeEquipment.length == homeEquipment.length &&
      other.homeEquipment.containsAll(homeEquipment) &&
      other.limitations.length == limitations.length &&
      other.limitations.containsAll(limitations);

  @override
  int get hashCode => Object.hash(
    environment,
    level,
    sessionMinutes,
    Object.hashAllUnordered(homeEquipment),
    Object.hashAllUnordered(limitations),
  );
}
