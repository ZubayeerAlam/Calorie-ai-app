import '../../../../l10n/l10n.dart';
import '../models/exercise.dart';

/// The words for an exercise in the app's language: its name, the
/// starting position, three steps (they match the demonstration's
/// phases), a form tip and the main benefit. The text lives in the ARB
/// files under `ex<Id>…` keys.
class ExerciseTexts {
  const ExerciseTexts({
    required this.name,
    required this.position,
    required this.steps,
    required this.tip,
    required this.benefit,
  });

  final String name;
  final String position;
  final List<String> steps;
  final String tip;
  final String benefit;

  /// Texts for the exercise [id], or null for an unknown id. Uses [loc]
  /// when given (tests), else the app's current language.
  static ExerciseTexts? of(String id, [AppLocalizations? loc]) {
    final l = loc ?? l10n;
    return switch (id) {
      'push_up' => ExerciseTexts(
        name: l.exPushUpName,
        position: l.exPushUpPosition,
        steps: [l.exPushUpStep1, l.exPushUpStep2, l.exPushUpStep3],
        tip: l.exPushUpTip,
        benefit: l.exPushUpBenefit,
      ),
      'knee_push_up' => ExerciseTexts(
        name: l.exKneePushUpName,
        position: l.exKneePushUpPosition,
        steps: [l.exKneePushUpStep1, l.exKneePushUpStep2, l.exKneePushUpStep3],
        tip: l.exKneePushUpTip,
        benefit: l.exKneePushUpBenefit,
      ),
      'incline_push_up' => ExerciseTexts(
        name: l.exInclinePushUpName,
        position: l.exInclinePushUpPosition,
        steps: [
          l.exInclinePushUpStep1,
          l.exInclinePushUpStep2,
          l.exInclinePushUpStep3,
        ],
        tip: l.exInclinePushUpTip,
        benefit: l.exInclinePushUpBenefit,
      ),
      'squat' => ExerciseTexts(
        name: l.exSquatName,
        position: l.exSquatPosition,
        steps: [l.exSquatStep1, l.exSquatStep2, l.exSquatStep3],
        tip: l.exSquatTip,
        benefit: l.exSquatBenefit,
      ),
      'lunge' => ExerciseTexts(
        name: l.exLungeName,
        position: l.exLungePosition,
        steps: [l.exLungeStep1, l.exLungeStep2, l.exLungeStep3],
        tip: l.exLungeTip,
        benefit: l.exLungeBenefit,
      ),
      'glute_bridge' => ExerciseTexts(
        name: l.exGluteBridgeName,
        position: l.exGluteBridgePosition,
        steps: [
          l.exGluteBridgeStep1,
          l.exGluteBridgeStep2,
          l.exGluteBridgeStep3,
        ],
        tip: l.exGluteBridgeTip,
        benefit: l.exGluteBridgeBenefit,
      ),
      'plank' => ExerciseTexts(
        name: l.exPlankName,
        position: l.exPlankPosition,
        steps: [l.exPlankStep1, l.exPlankStep2, l.exPlankStep3],
        tip: l.exPlankTip,
        benefit: l.exPlankBenefit,
      ),
      'side_plank' => ExerciseTexts(
        name: l.exSidePlankName,
        position: l.exSidePlankPosition,
        steps: [l.exSidePlankStep1, l.exSidePlankStep2, l.exSidePlankStep3],
        tip: l.exSidePlankTip,
        benefit: l.exSidePlankBenefit,
      ),
      'mountain_climber' => ExerciseTexts(
        name: l.exMountainClimberName,
        position: l.exMountainClimberPosition,
        steps: [
          l.exMountainClimberStep1,
          l.exMountainClimberStep2,
          l.exMountainClimberStep3,
        ],
        tip: l.exMountainClimberTip,
        benefit: l.exMountainClimberBenefit,
      ),
      'jumping_jack' => ExerciseTexts(
        name: l.exJumpingJackName,
        position: l.exJumpingJackPosition,
        steps: [
          l.exJumpingJackStep1,
          l.exJumpingJackStep2,
          l.exJumpingJackStep3,
        ],
        tip: l.exJumpingJackTip,
        benefit: l.exJumpingJackBenefit,
      ),
      'high_knees' => ExerciseTexts(
        name: l.exHighKneesName,
        position: l.exHighKneesPosition,
        steps: [l.exHighKneesStep1, l.exHighKneesStep2, l.exHighKneesStep3],
        tip: l.exHighKneesTip,
        benefit: l.exHighKneesBenefit,
      ),
      'superman' => ExerciseTexts(
        name: l.exSupermanName,
        position: l.exSupermanPosition,
        steps: [l.exSupermanStep1, l.exSupermanStep2, l.exSupermanStep3],
        tip: l.exSupermanTip,
        benefit: l.exSupermanBenefit,
      ),
      'bird_dog' => ExerciseTexts(
        name: l.exBirdDogName,
        position: l.exBirdDogPosition,
        steps: [l.exBirdDogStep1, l.exBirdDogStep2, l.exBirdDogStep3],
        tip: l.exBirdDogTip,
        benefit: l.exBirdDogBenefit,
      ),
      'wall_sit' => ExerciseTexts(
        name: l.exWallSitName,
        position: l.exWallSitPosition,
        steps: [l.exWallSitStep1, l.exWallSitStep2, l.exWallSitStep3],
        tip: l.exWallSitTip,
        benefit: l.exWallSitBenefit,
      ),
      'chair_dip' => ExerciseTexts(
        name: l.exChairDipName,
        position: l.exChairDipPosition,
        steps: [l.exChairDipStep1, l.exChairDipStep2, l.exChairDipStep3],
        tip: l.exChairDipTip,
        benefit: l.exChairDipBenefit,
      ),
      'step_up' => ExerciseTexts(
        name: l.exStepUpName,
        position: l.exStepUpPosition,
        steps: [l.exStepUpStep1, l.exStepUpStep2, l.exStepUpStep3],
        tip: l.exStepUpTip,
        benefit: l.exStepUpBenefit,
      ),
      'calf_raise' => ExerciseTexts(
        name: l.exCalfRaiseName,
        position: l.exCalfRaisePosition,
        steps: [l.exCalfRaiseStep1, l.exCalfRaiseStep2, l.exCalfRaiseStep3],
        tip: l.exCalfRaiseTip,
        benefit: l.exCalfRaiseBenefit,
      ),
      'dead_bug' => ExerciseTexts(
        name: l.exDeadBugName,
        position: l.exDeadBugPosition,
        steps: [l.exDeadBugStep1, l.exDeadBugStep2, l.exDeadBugStep3],
        tip: l.exDeadBugTip,
        benefit: l.exDeadBugBenefit,
      ),
      'goblet_squat' => ExerciseTexts(
        name: l.exGobletSquatName,
        position: l.exGobletSquatPosition,
        steps: [
          l.exGobletSquatStep1,
          l.exGobletSquatStep2,
          l.exGobletSquatStep3,
        ],
        tip: l.exGobletSquatTip,
        benefit: l.exGobletSquatBenefit,
      ),
      'dumbbell_row' => ExerciseTexts(
        name: l.exDumbbellRowName,
        position: l.exDumbbellRowPosition,
        steps: [
          l.exDumbbellRowStep1,
          l.exDumbbellRowStep2,
          l.exDumbbellRowStep3,
        ],
        tip: l.exDumbbellRowTip,
        benefit: l.exDumbbellRowBenefit,
      ),
      'shoulder_press' => ExerciseTexts(
        name: l.exShoulderPressName,
        position: l.exShoulderPressPosition,
        steps: [
          l.exShoulderPressStep1,
          l.exShoulderPressStep2,
          l.exShoulderPressStep3,
        ],
        tip: l.exShoulderPressTip,
        benefit: l.exShoulderPressBenefit,
      ),
      'romanian_deadlift' => ExerciseTexts(
        name: l.exRomanianDeadliftName,
        position: l.exRomanianDeadliftPosition,
        steps: [
          l.exRomanianDeadliftStep1,
          l.exRomanianDeadliftStep2,
          l.exRomanianDeadliftStep3,
        ],
        tip: l.exRomanianDeadliftTip,
        benefit: l.exRomanianDeadliftBenefit,
      ),
      'bicep_curl' => ExerciseTexts(
        name: l.exBicepCurlName,
        position: l.exBicepCurlPosition,
        steps: [l.exBicepCurlStep1, l.exBicepCurlStep2, l.exBicepCurlStep3],
        tip: l.exBicepCurlTip,
        benefit: l.exBicepCurlBenefit,
      ),
      'band_row' => ExerciseTexts(
        name: l.exBandRowName,
        position: l.exBandRowPosition,
        steps: [l.exBandRowStep1, l.exBandRowStep2, l.exBandRowStep3],
        tip: l.exBandRowTip,
        benefit: l.exBandRowBenefit,
      ),
      'band_pull_apart' => ExerciseTexts(
        name: l.exBandPullApartName,
        position: l.exBandPullApartPosition,
        steps: [
          l.exBandPullApartStep1,
          l.exBandPullApartStep2,
          l.exBandPullApartStep3,
        ],
        tip: l.exBandPullApartTip,
        benefit: l.exBandPullApartBenefit,
      ),
      'leg_press' => ExerciseTexts(
        name: l.exLegPressName,
        position: l.exLegPressPosition,
        steps: [l.exLegPressStep1, l.exLegPressStep2, l.exLegPressStep3],
        tip: l.exLegPressTip,
        benefit: l.exLegPressBenefit,
      ),
      'lat_pulldown' => ExerciseTexts(
        name: l.exLatPulldownName,
        position: l.exLatPulldownPosition,
        steps: [
          l.exLatPulldownStep1,
          l.exLatPulldownStep2,
          l.exLatPulldownStep3,
        ],
        tip: l.exLatPulldownTip,
        benefit: l.exLatPulldownBenefit,
      ),
      'seated_cable_row' => ExerciseTexts(
        name: l.exSeatedCableRowName,
        position: l.exSeatedCableRowPosition,
        steps: [
          l.exSeatedCableRowStep1,
          l.exSeatedCableRowStep2,
          l.exSeatedCableRowStep3,
        ],
        tip: l.exSeatedCableRowTip,
        benefit: l.exSeatedCableRowBenefit,
      ),
      'chest_press' => ExerciseTexts(
        name: l.exChestPressName,
        position: l.exChestPressPosition,
        steps: [l.exChestPressStep1, l.exChestPressStep2, l.exChestPressStep3],
        tip: l.exChestPressTip,
        benefit: l.exChestPressBenefit,
      ),
      'dumbbell_bench_press' => ExerciseTexts(
        name: l.exDumbbellBenchPressName,
        position: l.exDumbbellBenchPressPosition,
        steps: [
          l.exDumbbellBenchPressStep1,
          l.exDumbbellBenchPressStep2,
          l.exDumbbellBenchPressStep3,
        ],
        tip: l.exDumbbellBenchPressTip,
        benefit: l.exDumbbellBenchPressBenefit,
      ),
      'leg_curl' => ExerciseTexts(
        name: l.exLegCurlName,
        position: l.exLegCurlPosition,
        steps: [l.exLegCurlStep1, l.exLegCurlStep2, l.exLegCurlStep3],
        tip: l.exLegCurlTip,
        benefit: l.exLegCurlBenefit,
      ),
      'triceps_pushdown' => ExerciseTexts(
        name: l.exTricepsPushdownName,
        position: l.exTricepsPushdownPosition,
        steps: [
          l.exTricepsPushdownStep1,
          l.exTricepsPushdownStep2,
          l.exTricepsPushdownStep3,
        ],
        tip: l.exTricepsPushdownTip,
        benefit: l.exTricepsPushdownBenefit,
      ),
      'treadmill_incline_walk' => ExerciseTexts(
        name: l.exTreadmillInclineWalkName,
        position: l.exTreadmillInclineWalkPosition,
        steps: [
          l.exTreadmillInclineWalkStep1,
          l.exTreadmillInclineWalkStep2,
          l.exTreadmillInclineWalkStep3,
        ],
        tip: l.exTreadmillInclineWalkTip,
        benefit: l.exTreadmillInclineWalkBenefit,
      ),
      'stationary_bike' => ExerciseTexts(
        name: l.exStationaryBikeName,
        position: l.exStationaryBikePosition,
        steps: [
          l.exStationaryBikeStep1,
          l.exStationaryBikeStep2,
          l.exStationaryBikeStep3,
        ],
        tip: l.exStationaryBikeTip,
        benefit: l.exStationaryBikeBenefit,
      ),
      'rowing_machine' => ExerciseTexts(
        name: l.exRowingMachineName,
        position: l.exRowingMachinePosition,
        steps: [
          l.exRowingMachineStep1,
          l.exRowingMachineStep2,
          l.exRowingMachineStep3,
        ],
        tip: l.exRowingMachineTip,
        benefit: l.exRowingMachineBenefit,
      ),
      'march_in_place' => ExerciseTexts(
        name: l.exMarchInPlaceName,
        position: l.exMarchInPlacePosition,
        steps: [
          l.exMarchInPlaceStep1,
          l.exMarchInPlaceStep2,
          l.exMarchInPlaceStep3,
        ],
        tip: l.exMarchInPlaceTip,
        benefit: l.exMarchInPlaceBenefit,
      ),
      _ => null,
    };
  }

  /// The exercise's name, or its id when unknown (never empty).
  static String nameOf(String id, [AppLocalizations? loc]) =>
      of(id, loc)?.name ?? id;

  /// A muscle group's name.
  static String muscle(MuscleGroup muscle, [AppLocalizations? loc]) {
    final l = loc ?? l10n;
    return switch (muscle) {
      MuscleGroup.chest => l.muscleChest,
      MuscleGroup.shoulders => l.muscleShoulders,
      MuscleGroup.triceps => l.muscleTriceps,
      MuscleGroup.biceps => l.muscleBiceps,
      MuscleGroup.back => l.muscleBack,
      MuscleGroup.core => l.muscleCore,
      MuscleGroup.glutes => l.muscleGlutes,
      MuscleGroup.quads => l.muscleQuads,
      MuscleGroup.hamstrings => l.muscleHamstrings,
      MuscleGroup.calves => l.muscleCalves,
      MuscleGroup.fullBody => l.muscleFullBody,
      MuscleGroup.heart => l.muscleHeart,
    };
  }
}
