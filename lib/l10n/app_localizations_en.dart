// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get nothingToAnalyze => 'Nothing to analyse. Please go back.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get tryAgain => 'Try again';

  @override
  String get required => 'Required';

  @override
  String get today => 'Today';

  @override
  String kcalValue(String value) {
    return '$value kcal';
  }

  @override
  String gramsValue(String value) {
    return '$value g';
  }

  @override
  String kgValue(String value) {
    return '$value kg';
  }

  @override
  String lbValue(String value) {
    return '$value lb';
  }

  @override
  String cmValue(String value) {
    return '$value cm';
  }

  @override
  String get unitKg => 'kg';

  @override
  String get unitLb => 'lb';

  @override
  String get unitCm => 'cm';

  @override
  String get unitFt => 'ft';

  @override
  String get unitIn => 'in';

  @override
  String get unitKcal => 'kcal';

  @override
  String get unitGrams => 'g';

  @override
  String eatenOfTarget(String eaten, String target) {
    return '$eaten / $target kcal';
  }

  @override
  String percent(String value) {
    return '$value%';
  }

  @override
  String todayDate(String date) {
    return 'Today, $date';
  }

  @override
  String yesterdayDate(String date) {
    return 'Yesterday, $date';
  }

  @override
  String get authInvalidEmail => 'That email address doesn\'t look right.';

  @override
  String get authWrongCredentials => 'Wrong email or password.';

  @override
  String get authEmailInUse =>
      'An account with this email already exists. Sign in instead.';

  @override
  String get authWeakPassword => 'Use a password of at least 6 characters.';

  @override
  String get authNetwork => 'No connection. Check your internet and try again.';

  @override
  String get authTooManyRequests =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get authNotEnabled =>
      'Email sign-in isn\'t turned on for this app yet.';

  @override
  String get authUnknown => 'Something went wrong. Please try again.';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get backupUnreachable =>
      'Your backup couldn\'t be reached, so you weren\'t signed in. Check your connection and try again.';

  @override
  String get enterEmailFirst => 'Enter your email first.';

  @override
  String passwordResetSent(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String get createAccount => 'Create account';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInIntro =>
      'Back up your meals, weight and goals, and use them on another phone. The data already on this phone is kept and added to your account.';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHelper => 'At least 6 characters';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get haveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get newHereCreateAccount => 'New here? Create an account';

  @override
  String get logOutTitle => 'Log out?';

  @override
  String get logOutBody =>
      'Your data stays in your account and is removed from this phone. Sign in again to get it back.';

  @override
  String get logOut => 'Log out';

  @override
  String get backUpYourData => 'Back up your data';

  @override
  String get signedIn => 'Signed in';

  @override
  String get backUpPitch =>
      'Sign in to keep your meals and weight safe and use them on another phone.';

  @override
  String get backedUpSynced => 'Backed up and synced to your account';

  @override
  String get signInOrCreate => 'Sign in or create account';

  @override
  String healthAccessDenied(String app) {
    return 'Access wasn\'t allowed. You can allow it in $app settings.';
  }

  @override
  String healthInstall(String app) {
    return 'Install or update $app to import your steps and workouts.';
  }

  @override
  String get install => 'Install';

  @override
  String get healthImporting =>
      'Steps and workout calories are imported automatically.';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get healthPitch =>
      'Import all your steps (also those walked before opening the app) and the calories from your workouts.';

  @override
  String get connecting => 'Connecting…';

  @override
  String get connect => 'Connect';

  @override
  String healthConnected(String app) {
    return '$app connected';
  }

  @override
  String stepsCount(String steps) {
    return '$steps steps';
  }

  @override
  String get allowStepAccess => 'Allow step access';

  @override
  String get noStepSensor => 'No step sensor';

  @override
  String dailyGoalKcal(String kcal) {
    return 'Daily goal: $kcal kcal';
  }

  @override
  String goalKcalADay(String goal, String kcal) {
    return '$goal · $kcal kcal a day';
  }

  @override
  String get eaten => 'Eaten';

  @override
  String get burned => 'Burned';

  @override
  String get walking => 'Walking';

  @override
  String get activity => 'Activity';

  @override
  String get logActivity => 'Log activity';

  @override
  String get kcalOver => 'kcal over';

  @override
  String get kcalLeft => 'kcal left';

  @override
  String get yourCaloriePlan => 'Your calorie plan';

  @override
  String get caloriesAtRest => 'Calories at rest (BMR)';

  @override
  String withActivity(String factor) {
    return 'With activity × $factor';
  }

  @override
  String get goalAdjustment => 'Goal adjustment';

  @override
  String get recommendedDailyTarget => 'Recommended daily target';

  @override
  String raisedToMinimum(String kcal) {
    return 'Raised to the $kcal kcal minimum';
  }

  @override
  String get yourCustomTarget => 'Your custom target';

  @override
  String get setOnAccount => 'Set on Account';

  @override
  String get macros => 'Macros';

  @override
  String get carbs => 'Carbs';

  @override
  String get protein => 'Protein';

  @override
  String get fat => 'Fat';

  @override
  String macroShare(String percent, String kcal) {
    return '$percent · $kcal kcal/g';
  }

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get chooseDate => 'Choose a date';

  @override
  String get emptyToday =>
      'Nothing logged yet today. Tap ＋ on a meal to log food.';

  @override
  String get emptyDay =>
      'Nothing logged on this day. Tap ＋ on a meal to add it.';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String greetingName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String activitySheetSubtitle(String day) {
    return 'Calories burned from exercise · $day';
  }

  @override
  String plusHealthWorkouts(String kcal) {
    return 'Plus $kcal kcal from workouts in Health';
  }

  @override
  String get nothingLoggedYet => 'Nothing logged yet';

  @override
  String addToMeal(String meal) {
    return 'Add to $meal';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get keepWeightSteady => 'Keep your weight steady';

  @override
  String kgPerWeek(String value) {
    return '$value kg / week';
  }

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get age => 'Age';

  @override
  String get bmi => 'BMI';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snacks => 'Snacks';

  @override
  String get enterNumber => 'Enter a number';

  @override
  String get addFoodTitle => 'Add Food';

  @override
  String get scanPhoto => 'Scan a photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get foodName => 'Food name';

  @override
  String get caloriesKcal => 'Calories (kcal)';

  @override
  String get enterWholeCalories => 'Enter whole calories';

  @override
  String get macrosBlankHint =>
      'Leave protein, carbs and fat blank to estimate them from calories.';

  @override
  String get proteinG => 'Protein (g)';

  @override
  String get carbsG => 'Carbs (g)';

  @override
  String get fatG => 'Fat (g)';

  @override
  String get meal => 'Meal';

  @override
  String get addManually => 'Add manually';

  @override
  String get whatDidYouEat => 'What did you eat?';

  @override
  String get manualIntro =>
      'Describe your meal and the AI will estimate calories and macros. List several foods with commas.';

  @override
  String get yourMeal => 'Your meal';

  @override
  String get yourMealHint =>
      'e.g. 2 scrambled eggs, toast with butter, black coffee';

  @override
  String get moreDetails => 'More details (optional)';

  @override
  String get moreDetailsHint => 'These help the estimate be more accurate.';

  @override
  String get portionSize => 'Portion size';

  @override
  String get portionSizeHint => 'e.g. 1 large plate, 250 g';

  @override
  String get cookingMethod => 'Cooking method';

  @override
  String get cookingMethodHint => 'e.g. fried in oil, grilled, boiled';

  @override
  String get brandOrRestaurant => 'Brand or restaurant';

  @override
  String get brandHint => 'e.g. Starbucks, Nestlé';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get ingredientsHint => 'e.g. olive oil, cheese, sugar';

  @override
  String get enterNumbersMyself => 'Enter numbers myself';

  @override
  String get analyzeWithAi => 'Analyze with AI';

  @override
  String get addFood => 'Add food';

  @override
  String get howToAddMeal => 'How would you like to add your meal?';

  @override
  String get scanWithCamera => 'Scan with camera';

  @override
  String get scanWithCameraHint => 'Take or choose a photo of your meal';

  @override
  String get addManuallyHint => 'Describe your meal and get its nutrition';

  @override
  String get addFoodWithCamera => 'Add food with camera';

  @override
  String get aiEstimateTag => '(AI estimate)';

  @override
  String get estimatedTag => '(est.)';

  @override
  String macroShort(String protein, String carbs, String fat) {
    return 'P ${protein}g C ${carbs}g F ${fat}g';
  }

  @override
  String deleteEntry(String name) {
    return 'Delete $name';
  }

  @override
  String get detailPortion => 'Portion';

  @override
  String get detailCooking => 'Cooking';

  @override
  String get detailBrand => 'Brand';

  @override
  String get detailIngredients => 'Ingredients';

  @override
  String addedItemsToMeal(int count, String meal) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count items to $meal',
      one: 'Added 1 item to $meal',
    );
    return '$_temp0';
  }

  @override
  String get scanFood => 'Scan Food';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get useThisPhoto => 'Use this photo';

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required to scan food.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get imageLoadFailed => 'Could not load the image. Please try again.';

  @override
  String get noFoodFound => 'No food found';

  @override
  String get noFoodFoundPhoto =>
      'We couldn\'t spot any food in this photo. Try another photo, or enter the food yourself.';

  @override
  String get noFoodRecognised => 'No food recognised';

  @override
  String get noFoodRecognisedText =>
      'We couldn\'t find any food in what you wrote. Try describing it differently, or enter the numbers yourself.';

  @override
  String get cantReachAnalysis => 'Can\'t reach the analysis service';

  @override
  String get checkConnection => 'Check your connection and try again.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get analysisFailed =>
      'The analysis didn\'t work this time. Try again, or enter the food yourself.';

  @override
  String get tryAnotherPhoto => 'Try another photo';

  @override
  String get editDescription => 'Edit description';

  @override
  String get enterItManually => 'Enter it manually';

  @override
  String get analyzingMeal => 'Analyzing your meal…';

  @override
  String get takesFewSeconds => 'This usually takes a few seconds.';

  @override
  String get allItemsRemoved => 'All items removed';

  @override
  String weFoundItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'We found $count items',
      one: 'We found 1 item',
    );
    return '$_temp0';
  }

  @override
  String get goBackAnotherPhoto => 'Go back to try another photo.';

  @override
  String get goBackEditDescription => 'Go back to edit your description.';

  @override
  String get aiEstimateCheck => 'AI estimate · check and edit before saving';

  @override
  String get addTo => 'Add to';

  @override
  String addToMealKcal(String meal, String kcal) {
    return 'Add to $meal · $kcal kcal';
  }

  @override
  String get addAName => 'Add a name';

  @override
  String removeItem(String name) {
    return 'Remove $name';
  }

  @override
  String get portion => 'Portion';

  @override
  String get calories => 'Calories';

  @override
  String get demoPhoto =>
      'Demo result: AI analysis isn\'t connected yet, so these are sample foods, not what\'s in your photo. Edit them before saving.';

  @override
  String get demoText =>
      'Demo result: AI analysis isn\'t connected yet, so these are sample numbers, not real nutrition for what you typed. Edit them before saving.';

  @override
  String get youDescribed => 'You described';

  @override
  String detailLine(String label) {
    return '$label: ';
  }

  @override
  String get tabHome => 'Home';

  @override
  String get tabTracker => 'Tracker';

  @override
  String get tabExercise => 'Exercise';

  @override
  String get tabAccount => 'Account';

  @override
  String get howActive => 'How active are you?';

  @override
  String get whenBorn => 'When were you born?';

  @override
  String ageRange(String min, String max) {
    return 'You must be between $min and $max years old.';
  }

  @override
  String get specificDiet => 'Do you follow a specific diet?';

  @override
  String get whenDinner => 'When do you usually have\ndinner?';

  @override
  String get chooseGender => 'Choose your gender';

  @override
  String get mainGoal => 'What\'s your main goal?';

  @override
  String get howTall => 'How tall are you?';

  @override
  String get ftIn => 'ft / in';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get yourName => 'Your name';

  @override
  String personalizing(String app) {
    return 'Personalizing your $app\nexperience...';
  }

  @override
  String get hangTight =>
      'Hang tight! We\'re crafting a personalized plan just for you.';

  @override
  String get planReady => 'Your plan is ready';

  @override
  String get caloriesPerDay => 'calories per day';

  @override
  String kgPerWeekSigned(String value) {
    return '$value kg per week';
  }

  @override
  String get whatsYourWeight => 'What\'s your weight?';

  @override
  String get finish => 'Finish';

  @override
  String get continueButton => 'Continue';

  @override
  String stepOf(String step, String total) {
    return '$step / $total';
  }

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get goalLose => 'Lose weight';

  @override
  String get goalMaintain => 'Maintain weight';

  @override
  String get goalGain => 'Gain weight';

  @override
  String get focusGainMuscle => 'Gain muscle';

  @override
  String get focusBoostEnergy => 'Boost energy';

  @override
  String get focusImproveNutrition => 'Improve nutrition';

  @override
  String get activitySedentary => 'Sedentary';

  @override
  String get activityLight => 'Lightly active';

  @override
  String get activityModerate => 'Moderately active';

  @override
  String get activityActive => 'Very active';

  @override
  String get activitySedentaryDesc => 'Little or no exercise, desk job';

  @override
  String get activityLightDesc => 'Light exercise 1–3 days a week';

  @override
  String get activityModerateDesc => 'Moderate exercise 3–5 days a week';

  @override
  String get activityActiveDesc => 'Hard exercise 6–7 days a week';

  @override
  String get dietClassic => 'Classic';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietPescatarian => 'Pescatarian';

  @override
  String get dietKeto => 'Keto';

  @override
  String get dietClassicDesc => 'No restrictions';

  @override
  String get dietVegetarianDesc => 'No meat or fish';

  @override
  String get dietVeganDesc => 'No animal products';

  @override
  String get dietPescatarianDesc => 'Fish but no meat';

  @override
  String get dietKetoDesc => 'High fat, very low carb';

  @override
  String get bmiUnderweight => 'Underweight';

  @override
  String get bmiHealthy => 'Healthy';

  @override
  String get bmiOverweight => 'Overweight';

  @override
  String get bmiObese => 'Obese';

  @override
  String get birthday => 'Birthday';

  @override
  String get usualDinnerTime => 'Usual dinner time';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get name => 'Name';

  @override
  String get units => 'Units';

  @override
  String get unitsMetric => 'kg · cm';

  @override
  String get unitsImperial => 'lb · ft';

  @override
  String get logWeightOnTracker => 'Log a new weight on the Tracker tab.';

  @override
  String ageValue(String age) {
    return 'Age $age';
  }

  @override
  String get gender => 'Gender';

  @override
  String get weightGoal => 'Weight goal';

  @override
  String get weightGoalHint => 'This sets your calorie target.';

  @override
  String get alsoFocusOn => 'Also focus on';

  @override
  String get activityLevel => 'Activity level';

  @override
  String get diet => 'Diet';

  @override
  String get heightRangeError =>
      'Enter a height between 100 and 250 cm (3′4″–8′2″)';

  @override
  String get profileAndGoals => 'Profile & Goals';

  @override
  String dailyCalorieGoal(String kcal) {
    return 'Daily calorie goal: $kcal kcal';
  }

  @override
  String customRecommended(String kcal) {
    return 'Custom · recommended $kcal kcal';
  }

  @override
  String get recommendedForProfile => 'Recommended for your profile';

  @override
  String get resetToRecommended => 'Reset to recommended';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String profileSummary(
    String age,
    String height,
    String weight,
    String goal,
    String activity,
  ) {
    return '$age years · $height · $weight\n$goal · $activity';
  }

  @override
  String get resetAllDataTitle => 'Reset all data?';

  @override
  String get resetSignedIn =>
      'This deletes your profile, meals, weight and activity from this phone and from your account, and starts again with setup. You\'ll stay signed in. This can\'t be undone.';

  @override
  String get resetLocal =>
      'This deletes your profile, meals, weight and activity from this phone and starts again with setup. This can\'t be undone.';

  @override
  String get deleteEverything => 'Delete everything';

  @override
  String get resetAllData => 'Reset all data';

  @override
  String get notificationsOff =>
      'Notifications are turned off for Cal AI. Allow them in your phone\'s settings to get reminders.';

  @override
  String get reminders => 'Reminders';

  @override
  String get remindersIntro =>
      'Turn on a reminder and Cal AI will nudge you to log your meals. A reminder is skipped once that meal is logged.';

  @override
  String get mealReminders => 'Meal reminders';

  @override
  String get mealRemindersChannelDesc =>
      'Reminders to log breakfast, lunch and dinner';

  @override
  String get dinnerTimeFromProfile => 'Your dinner time from your profile';

  @override
  String mealReminder(String meal) {
    return '$meal reminder';
  }

  @override
  String get logged => 'Logged';

  @override
  String reminderAt(String time) {
    return 'Reminder at $time';
  }

  @override
  String notLoggedYet(String time) {
    return 'Not logged yet · $time';
  }

  @override
  String get logNow => 'Log now';

  @override
  String get reminderBody => 'Log what you eat to stay on track today.';

  @override
  String get reminderBreakfast => 'Time for breakfast';

  @override
  String get reminderLunch => 'Time for lunch';

  @override
  String get reminderDinner => 'Dinner time';

  @override
  String get reminderSnack => 'Snack time';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get tracker => 'Tracker';

  @override
  String targetDashedLine(String kcal) {
    return 'Target $kcal kcal · dashed line';
  }

  @override
  String get onTarget => 'On target';

  @override
  String get under => 'Under';

  @override
  String get over => 'Over';

  @override
  String get history => 'History';

  @override
  String get nothingInPeriod => 'Nothing logged in this period yet';

  @override
  String get tapDayToOpen => 'Tap a day to open it on Home';

  @override
  String historyMacros(String protein, String carbs, String fat) {
    return 'P $protein g · C $carbs g · F $fat g';
  }

  @override
  String get logWeight => 'Log weight';

  @override
  String get logWeightSubtitle =>
      'Today\'s weight. Your calorie target follows it.';

  @override
  String get realisticWeight => 'Enter a realistic weight';

  @override
  String get dailyAverageLogged => 'Daily average on logged days';

  @override
  String gramsOfTarget(String value, String target) {
    return '$value / $target g';
  }

  @override
  String get steps => 'Steps';

  @override
  String get noStepsYet => 'No steps counted yet';

  @override
  String stepsAverage(String avg, String total) {
    return 'Avg $avg a day · $total total';
  }

  @override
  String get dayStreak => 'day streak';

  @override
  String get avgKcalDay => 'avg kcal / day';

  @override
  String get daysOnTarget => 'days on target';

  @override
  String get logWeightTrend => 'Log your weight to see the trend';

  @override
  String changeInPeriod(String change) {
    return '$change in this period';
  }

  @override
  String get log => 'Log';

  @override
  String get exPushUpName => 'Push-up';

  @override
  String get exPushUpPosition =>
      'Hands under your shoulders, body in a straight line from head to heels.';

  @override
  String get exPushUpStep1 => 'Start at the top with your arms straight.';

  @override
  String get exPushUpStep2 =>
      'Bend your elbows and lower your chest to just above the floor.';

  @override
  String get exPushUpStep3 =>
      'Push the floor away until your arms are straight again.';

  @override
  String get exPushUpTip =>
      'Keep your hips level; don\'t let them sag or lift.';

  @override
  String get exPushUpBenefit => 'Builds upper-body strength and endurance.';

  @override
  String get exKneePushUpName => 'Knee push-up';

  @override
  String get exKneePushUpPosition =>
      'Knees on the floor, hands under your shoulders, body straight from head to knees.';

  @override
  String get exKneePushUpStep1 => 'Start with your arms straight.';

  @override
  String get exKneePushUpStep2 => 'Lower your chest towards the floor.';

  @override
  String get exKneePushUpStep3 => 'Push back up until your arms are straight.';

  @override
  String get exKneePushUpTip =>
      'Keep your stomach tight so your back stays flat.';

  @override
  String get exKneePushUpBenefit =>
      'An easier push-up that builds chest and arm strength.';

  @override
  String get exInclinePushUpName => 'Incline push-up';

  @override
  String get exInclinePushUpPosition =>
      'Hands on a sturdy table or chair edge, feet back, body in a straight line.';

  @override
  String get exInclinePushUpStep1 => 'Start with your arms straight.';

  @override
  String get exInclinePushUpStep2 =>
      'Bend your elbows to bring your chest to the edge.';

  @override
  String get exInclinePushUpStep3 => 'Push back until your arms are straight.';

  @override
  String get exInclinePushUpTip => 'Make sure the chair or table can\'t slide.';

  @override
  String get exInclinePushUpBenefit =>
      'An easier push-up for building up to the full one.';

  @override
  String get exSquatName => 'Squat';

  @override
  String get exSquatPosition =>
      'Feet shoulder-width apart, toes slightly out, chest up.';

  @override
  String get exSquatStep1 => 'Stand tall with your weight on your heels.';

  @override
  String get exSquatStep2 =>
      'Push your hips back and bend your knees as if sitting on a chair.';

  @override
  String get exSquatStep3 => 'Push through your heels to stand back up.';

  @override
  String get exSquatTip => 'Keep your knees in line with your toes.';

  @override
  String get exSquatBenefit =>
      'Strengthens legs and glutes for everyday movement.';

  @override
  String get exLungeName => 'Lunge';

  @override
  String get exLungePosition =>
      'Stand tall, feet hip-width apart, hands on your hips.';

  @override
  String get exLungeStep1 => 'Take a big step forward.';

  @override
  String get exLungeStep2 => 'Lower until both knees are bent at about 90°.';

  @override
  String get exLungeStep3 =>
      'Push off the front foot back to standing; switch legs.';

  @override
  String get exLungeTip =>
      'Keep your front knee over your ankle, not past your toes.';

  @override
  String get exLungeBenefit =>
      'Builds leg strength and balance, one leg at a time.';

  @override
  String get exGluteBridgeName => 'Glute bridge';

  @override
  String get exGluteBridgePosition =>
      'Lie on your back, knees bent, feet flat and hip-width apart.';

  @override
  String get exGluteBridgeStep1 => 'Rest your arms by your sides.';

  @override
  String get exGluteBridgeStep2 =>
      'Squeeze your glutes and lift your hips until your body is straight from knees to shoulders.';

  @override
  String get exGluteBridgeStep3 => 'Lower your hips slowly back down.';

  @override
  String get exGluteBridgeTip =>
      'Push through your heels and don\'t arch your lower back.';

  @override
  String get exGluteBridgeBenefit =>
      'Strengthens glutes and the back of the legs; kind to the knees.';

  @override
  String get exPlankName => 'Plank';

  @override
  String get exPlankPosition =>
      'Forearms on the floor under your shoulders, legs straight behind you.';

  @override
  String get exPlankStep1 =>
      'Lift your body so it forms a straight line from head to heels.';

  @override
  String get exPlankStep2 => 'Tighten your stomach and glutes.';

  @override
  String get exPlankStep3 => 'Hold the position and keep breathing.';

  @override
  String get exPlankTip => 'Don\'t let your hips drop or rise.';

  @override
  String get exPlankBenefit => 'Builds core strength that supports your back.';

  @override
  String get exSidePlankName => 'Side plank';

  @override
  String get exSidePlankPosition =>
      'Lie on your side, forearm under your shoulder, legs stacked.';

  @override
  String get exSidePlankStep1 => 'Lift your hips so your body is straight.';

  @override
  String get exSidePlankStep2 => 'Hold, keeping your hips high.';

  @override
  String get exSidePlankStep3 => 'Lower slowly; switch sides.';

  @override
  String get exSidePlankTip => 'Keep your elbow right under your shoulder.';

  @override
  String get exSidePlankBenefit =>
      'Strengthens the sides of your core and improves stability.';

  @override
  String get exMountainClimberName => 'Mountain climber';

  @override
  String get exMountainClimberPosition =>
      'High plank: hands under your shoulders, body straight.';

  @override
  String get exMountainClimberStep1 => 'Bring one knee towards your chest.';

  @override
  String get exMountainClimberStep2 =>
      'Switch legs quickly, like running in place.';

  @override
  String get exMountainClimberStep3 =>
      'Keep going at a steady pace for the set time.';

  @override
  String get exMountainClimberTip =>
      'Keep your hips low and your shoulders over your hands.';

  @override
  String get exMountainClimberBenefit =>
      'Raises your heart rate while working your core.';

  @override
  String get exJumpingJackName => 'Jumping jack';

  @override
  String get exJumpingJackPosition =>
      'Stand with feet together and arms by your sides.';

  @override
  String get exJumpingJackStep1 =>
      'Jump your feet apart while raising your arms overhead.';

  @override
  String get exJumpingJackStep2 => 'Jump back to the start.';

  @override
  String get exJumpingJackStep3 =>
      'Repeat at a steady rhythm for the set time.';

  @override
  String get exJumpingJackTip => 'Land softly on the balls of your feet.';

  @override
  String get exJumpingJackBenefit =>
      'A simple cardio move that warms up the whole body.';

  @override
  String get exHighKneesName => 'High knees';

  @override
  String get exHighKneesPosition => 'Stand tall, feet hip-width apart.';

  @override
  String get exHighKneesStep1 =>
      'Run in place, lifting one knee to hip height.';

  @override
  String get exHighKneesStep2 => 'Switch legs quickly, pumping your arms.';

  @override
  String get exHighKneesStep3 => 'Keep going for the set time.';

  @override
  String get exHighKneesTip => 'Stay on the balls of your feet and stand tall.';

  @override
  String get exHighKneesBenefit =>
      'Raises your heart rate and works your legs.';

  @override
  String get exSupermanName => 'Superman';

  @override
  String get exSupermanPosition =>
      'Lie face down, arms stretched out in front, legs straight.';

  @override
  String get exSupermanStep1 => 'Look at the floor to keep your neck relaxed.';

  @override
  String get exSupermanStep2 =>
      'Lift your arms, chest and legs a little off the floor.';

  @override
  String get exSupermanStep3 => 'Hold for a moment, then lower slowly.';

  @override
  String get exSupermanTip =>
      'Lift only a few centimetres; don\'t throw your head back.';

  @override
  String get exSupermanBenefit => 'Strengthens the muscles along your back.';

  @override
  String get exBirdDogName => 'Bird dog';

  @override
  String get exBirdDogPosition =>
      'On hands and knees, hands under shoulders, knees under hips.';

  @override
  String get exBirdDogStep1 => 'Keep your back flat.';

  @override
  String get exBirdDogStep2 =>
      'Reach one arm forward and the opposite leg back.';

  @override
  String get exBirdDogStep3 => 'Return slowly and switch sides.';

  @override
  String get exBirdDogTip => 'Move slowly; keep your hips level.';

  @override
  String get exBirdDogBenefit =>
      'Improves balance and core control and supports the back.';

  @override
  String get exWallSitName => 'Wall sit';

  @override
  String get exWallSitPosition =>
      'Back flat against a wall, feet about 60 cm in front of it.';

  @override
  String get exWallSitStep1 =>
      'Slide down until your knees are bent at about 90°.';

  @override
  String get exWallSitStep2 => 'Hold with your weight in your heels.';

  @override
  String get exWallSitStep3 => 'Slide back up to stand.';

  @override
  String get exWallSitTip => 'Keep your knees over your ankles.';

  @override
  String get exWallSitBenefit =>
      'Builds thigh endurance without any equipment.';

  @override
  String get exChairDipName => 'Chair dip';

  @override
  String get exChairDipPosition =>
      'Hands on the edge of a sturdy chair behind you, legs out in front.';

  @override
  String get exChairDipStep1 => 'Start with your arms straight.';

  @override
  String get exChairDipStep2 => 'Bend your elbows to lower your body.';

  @override
  String get exChairDipStep3 => 'Push back up until your arms are straight.';

  @override
  String get exChairDipTip =>
      'Keep your back close to the chair and your shoulders down.';

  @override
  String get exChairDipBenefit => 'Strengthens the backs of your arms.';

  @override
  String get exStepUpName => 'Step-up';

  @override
  String get exStepUpPosition => 'Face a sturdy step or low bench.';

  @override
  String get exStepUpStep1 =>
      'Step up with one foot, pressing through the heel.';

  @override
  String get exStepUpStep2 => 'Bring the other foot up and stand tall.';

  @override
  String get exStepUpStep3 => 'Step down and switch the leading leg.';

  @override
  String get exStepUpTip =>
      'Use a step that can\'t move; hold a wall for balance if needed.';

  @override
  String get exStepUpBenefit =>
      'Strengthens legs and helps with stairs and climbing.';

  @override
  String get exCalfRaiseName => 'Calf raise';

  @override
  String get exCalfRaisePosition =>
      'Stand tall, feet hip-width apart, holding a wall for balance.';

  @override
  String get exCalfRaiseStep1 => 'Rise up onto the balls of your feet.';

  @override
  String get exCalfRaiseStep2 => 'Pause at the top.';

  @override
  String get exCalfRaiseStep3 => 'Lower your heels slowly.';

  @override
  String get exCalfRaiseTip => 'Move slowly; don\'t bounce.';

  @override
  String get exCalfRaiseBenefit => 'Strengthens the calves and ankles.';

  @override
  String get exDeadBugName => 'Dead bug';

  @override
  String get exDeadBugPosition =>
      'Lie on your back, arms up, knees bent at 90° above your hips.';

  @override
  String get exDeadBugStep1 => 'Press your lower back into the floor.';

  @override
  String get exDeadBugStep2 =>
      'Lower one arm and the opposite leg towards the floor.';

  @override
  String get exDeadBugStep3 => 'Return and switch sides.';

  @override
  String get exDeadBugTip => 'Keep your lower back flat the whole time.';

  @override
  String get exDeadBugBenefit =>
      'Builds core control with little strain on the back.';

  @override
  String get exGobletSquatName => 'Goblet squat';

  @override
  String get exGobletSquatPosition =>
      'Hold one dumbbell upright at your chest, feet shoulder-width apart.';

  @override
  String get exGobletSquatStep1 => 'Stand tall with your elbows pointing down.';

  @override
  String get exGobletSquatStep2 => 'Push your hips back and squat down.';

  @override
  String get exGobletSquatStep3 => 'Push through your heels to stand up.';

  @override
  String get exGobletSquatTip =>
      'Keep your chest up and the weight close to you.';

  @override
  String get exGobletSquatBenefit =>
      'Builds leg and glute strength with extra load.';

  @override
  String get exDumbbellRowName => 'Dumbbell row';

  @override
  String get exDumbbellRowPosition =>
      'One hand and knee on a bench or chair, dumbbell in the other hand, back flat.';

  @override
  String get exDumbbellRowStep1 => 'Let the arm hang straight down.';

  @override
  String get exDumbbellRowStep2 => 'Pull the dumbbell up towards your hip.';

  @override
  String get exDumbbellRowStep3 => 'Lower it slowly.';

  @override
  String get exDumbbellRowTip => 'Keep your back flat and don\'t twist.';

  @override
  String get exDumbbellRowBenefit =>
      'Strengthens the upper back and improves posture.';

  @override
  String get exShoulderPressName => 'Shoulder press';

  @override
  String get exShoulderPressPosition =>
      'Sit or stand tall, dumbbells at shoulder height, palms forward.';

  @override
  String get exShoulderPressStep1 => 'Brace your stomach.';

  @override
  String get exShoulderPressStep2 =>
      'Press the dumbbells straight up overhead.';

  @override
  String get exShoulderPressStep3 => 'Lower them back to your shoulders.';

  @override
  String get exShoulderPressTip =>
      'Don\'t arch your back; keep your ribs down.';

  @override
  String get exShoulderPressBenefit =>
      'Builds shoulder and arm strength for lifting overhead.';

  @override
  String get exRomanianDeadliftName => 'Romanian deadlift';

  @override
  String get exRomanianDeadliftPosition =>
      'Stand with dumbbells in front of your thighs, knees slightly bent.';

  @override
  String get exRomanianDeadliftStep1 =>
      'Keep your back flat and shoulders back.';

  @override
  String get exRomanianDeadliftStep2 =>
      'Push your hips back and lower the weights along your legs.';

  @override
  String get exRomanianDeadliftStep3 => 'Squeeze your glutes to stand up.';

  @override
  String get exRomanianDeadliftTip =>
      'Hinge at the hips; your back stays straight.';

  @override
  String get exRomanianDeadliftBenefit =>
      'Strengthens the back of the legs and the glutes.';

  @override
  String get exBicepCurlName => 'Biceps curl';

  @override
  String get exBicepCurlPosition =>
      'Stand tall, dumbbells at your sides, palms forward.';

  @override
  String get exBicepCurlStep1 => 'Keep your elbows close to your body.';

  @override
  String get exBicepCurlStep2 => 'Curl the weights up towards your shoulders.';

  @override
  String get exBicepCurlStep3 => 'Lower them slowly.';

  @override
  String get exBicepCurlTip => 'Don\'t swing; only your forearms move.';

  @override
  String get exBicepCurlBenefit => 'Strengthens the front of the arms.';

  @override
  String get exBandRowName => 'Band row';

  @override
  String get exBandRowPosition =>
      'Sit with legs straight, band around your feet, ends in your hands.';

  @override
  String get exBandRowStep1 => 'Sit tall with your arms straight.';

  @override
  String get exBandRowStep2 =>
      'Pull the ends towards your waist, squeezing your shoulder blades.';

  @override
  String get exBandRowStep3 => 'Return slowly.';

  @override
  String get exBandRowTip => 'Keep your back straight; don\'t lean back.';

  @override
  String get exBandRowBenefit =>
      'Strengthens the upper back with light, joint-friendly resistance.';

  @override
  String get exBandPullApartName => 'Band pull-apart';

  @override
  String get exBandPullApartPosition =>
      'Stand tall, hold a band in front of you at shoulder height.';

  @override
  String get exBandPullApartStep1 => 'Keep your arms straight.';

  @override
  String get exBandPullApartStep2 =>
      'Pull the band apart until it touches your chest.';

  @override
  String get exBandPullApartStep3 => 'Return slowly.';

  @override
  String get exBandPullApartTip =>
      'Squeeze your shoulder blades; keep your shoulders down.';

  @override
  String get exBandPullApartBenefit =>
      'Strengthens the upper back and shoulders and helps posture.';

  @override
  String get exLegPressName => 'Leg press';

  @override
  String get exLegPressPosition =>
      'Sit in the machine, back flat on the pad, feet shoulder-width on the platform.';

  @override
  String get exLegPressStep1 => 'Release the safety and hold the handles.';

  @override
  String get exLegPressStep2 =>
      'Bend your knees to lower the platform towards you.';

  @override
  String get exLegPressStep3 =>
      'Press it away until your legs are almost straight.';

  @override
  String get exLegPressTip => 'Don\'t lock your knees at the top.';

  @override
  String get exLegPressBenefit => 'Builds leg strength with back support.';

  @override
  String get exLatPulldownName => 'Lat pulldown';

  @override
  String get exLatPulldownPosition =>
      'Sit with thighs under the pad, hold the bar wider than your shoulders.';

  @override
  String get exLatPulldownStep1 => 'Sit tall and lean back slightly.';

  @override
  String get exLatPulldownStep2 => 'Pull the bar down to your upper chest.';

  @override
  String get exLatPulldownStep3 =>
      'Let it rise slowly until your arms are straight.';

  @override
  String get exLatPulldownTip =>
      'Pull with your elbows; don\'t pull behind your neck.';

  @override
  String get exLatPulldownBenefit =>
      'Strengthens the back and arms for pulling.';

  @override
  String get exSeatedCableRowName => 'Seated cable row';

  @override
  String get exSeatedCableRowPosition =>
      'Sit at the cable station, feet on the platform, knees soft, handle in both hands.';

  @override
  String get exSeatedCableRowStep1 => 'Sit tall with your arms straight.';

  @override
  String get exSeatedCableRowStep2 =>
      'Pull the handle to your stomach, squeezing your shoulder blades.';

  @override
  String get exSeatedCableRowStep3 => 'Return slowly.';

  @override
  String get exSeatedCableRowTip => 'Keep your back straight; don\'t rock.';

  @override
  String get exSeatedCableRowBenefit =>
      'Strengthens the middle back and improves posture.';

  @override
  String get exChestPressName => 'Chest press';

  @override
  String get exChestPressPosition =>
      'Sit with your back against the pad, handles at chest height.';

  @override
  String get exChestPressStep1 => 'Hold the handles with your elbows bent.';

  @override
  String get exChestPressStep2 =>
      'Push the handles forward until your arms are straight.';

  @override
  String get exChestPressStep3 => 'Return slowly.';

  @override
  String get exChestPressTip => 'Keep your shoulders back against the pad.';

  @override
  String get exChestPressBenefit =>
      'Builds chest and arm strength with a guided path.';

  @override
  String get exDumbbellBenchPressName => 'Dumbbell bench press';

  @override
  String get exDumbbellBenchPressPosition =>
      'Lie on a flat bench, dumbbells above your chest, feet on the floor.';

  @override
  String get exDumbbellBenchPressStep1 =>
      'Start with your arms straight above you.';

  @override
  String get exDumbbellBenchPressStep2 =>
      'Lower the dumbbells to the sides of your chest.';

  @override
  String get exDumbbellBenchPressStep3 => 'Press them back up.';

  @override
  String get exDumbbellBenchPressTip =>
      'Control the weights; keep your wrists straight.';

  @override
  String get exDumbbellBenchPressBenefit =>
      'Builds chest, shoulder and arm strength.';

  @override
  String get exLegCurlName => 'Leg curl';

  @override
  String get exLegCurlPosition =>
      'Sit or lie in the machine with the pad just above your heels.';

  @override
  String get exLegCurlStep1 => 'Hold the handles and keep your hips down.';

  @override
  String get exLegCurlStep2 => 'Bend your knees to curl the pad towards you.';

  @override
  String get exLegCurlStep3 => 'Return slowly.';

  @override
  String get exLegCurlTip => 'Move smoothly; don\'t lift your hips.';

  @override
  String get exLegCurlBenefit =>
      'Strengthens the hamstrings (back of the thighs).';

  @override
  String get exTricepsPushdownName => 'Triceps pushdown';

  @override
  String get exTricepsPushdownPosition =>
      'Stand at a high cable with a bar or rope, elbows at your sides.';

  @override
  String get exTricepsPushdownStep1 => 'Start with your elbows bent.';

  @override
  String get exTricepsPushdownStep2 =>
      'Push down until your arms are straight.';

  @override
  String get exTricepsPushdownStep3 => 'Let the handle rise slowly.';

  @override
  String get exTricepsPushdownTip => 'Keep your elbows still at your sides.';

  @override
  String get exTricepsPushdownBenefit => 'Strengthens the backs of the arms.';

  @override
  String get exTreadmillInclineWalkName => 'Incline treadmill walk';

  @override
  String get exTreadmillInclineWalkPosition =>
      'Stand on the treadmill, set a gentle incline and a brisk walking speed.';

  @override
  String get exTreadmillInclineWalkStep1 => 'Walk tall, looking ahead.';

  @override
  String get exTreadmillInclineWalkStep2 => 'Swing your arms naturally.';

  @override
  String get exTreadmillInclineWalkStep3 =>
      'Keep a pace where you can talk but feel warm.';

  @override
  String get exTreadmillInclineWalkTip =>
      'Hold the rails only for balance, not to lean back.';

  @override
  String get exTreadmillInclineWalkBenefit =>
      'Raises your heart rate with low impact on the joints.';

  @override
  String get exStationaryBikeName => 'Stationary bike';

  @override
  String get exStationaryBikePosition =>
      'Adjust the seat so your knee is slightly bent at the bottom of the pedal stroke.';

  @override
  String get exStationaryBikeStep1 =>
      'Sit tall and hold the handlebars lightly.';

  @override
  String get exStationaryBikeStep2 => 'Pedal at a steady, comfortable pace.';

  @override
  String get exStationaryBikeStep3 => 'Add resistance if it feels too easy.';

  @override
  String get exStationaryBikeTip => 'Keep your knees in line with your feet.';

  @override
  String get exStationaryBikeBenefit =>
      'Builds heart fitness with low impact on the joints.';

  @override
  String get exRowingMachineName => 'Rowing machine';

  @override
  String get exRowingMachinePosition =>
      'Sit on the rower, feet strapped in, handle in both hands, arms straight.';

  @override
  String get exRowingMachineStep1 => 'Push with your legs first.';

  @override
  String get exRowingMachineStep2 =>
      'Lean back slightly and pull the handle to your lower ribs.';

  @override
  String get exRowingMachineStep3 =>
      'Return arms, then body, then legs, in that order.';

  @override
  String get exRowingMachineTip =>
      'Power comes from your legs; keep your back straight.';

  @override
  String get exRowingMachineBenefit =>
      'A full-body cardio workout for legs, back and heart.';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleQuads => 'Thighs (front)';

  @override
  String get muscleHamstrings => 'Thighs (back)';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleFullBody => 'Full body';

  @override
  String get muscleHeart => 'Heart and lungs';

  @override
  String get exMarchInPlaceName => 'March in place';

  @override
  String get exMarchInPlacePosition =>
      'Stand tall, feet hip-width apart, arms relaxed.';

  @override
  String get exMarchInPlaceStep1 => 'Lift one knee to a comfortable height.';

  @override
  String get exMarchInPlaceStep2 =>
      'Lower it and lift the other, swinging your arms.';

  @override
  String get exMarchInPlaceStep3 =>
      'Keep a brisk, steady rhythm for the set time.';

  @override
  String get exMarchInPlaceTip =>
      'Land softly; lift your knees only as high as feels good.';

  @override
  String get exMarchInPlaceBenefit =>
      'Low-impact cardio that gets your heart going gently.';

  @override
  String planDay(String letter) {
    return 'Day $letter';
  }

  @override
  String planFullBody(String letter) {
    return 'Full body $letter';
  }

  @override
  String planUpperBody(String letter) {
    return 'Upper body $letter';
  }

  @override
  String planLowerBody(String letter) {
    return 'Lower body $letter';
  }

  @override
  String get planFocusFullBody => 'Legs, push, pull, core and cardio';

  @override
  String get planFocusUpperBody => 'Chest, back, shoulders and arms';

  @override
  String get planFocusLowerBody => 'Legs, glutes and core';

  @override
  String rulesPlanSummary(int count) {
    return '$count workouts a week, made on your phone from your profile.';
  }

  @override
  String get exerciseSetupTitle => 'Workout setup';

  @override
  String get exerciseIntroTitle => 'Where do you work out?';

  @override
  String get exerciseIntroBody =>
      'Pick one and we\'ll make a weekly plan for your profile and goals. You can change it any time.';

  @override
  String get envHome => 'Home workout';

  @override
  String get envHomeDesc =>
      'Bodyweight exercises, no gym needed. Add dumbbells or bands if you have them.';

  @override
  String get envGym => 'Gym workout';

  @override
  String get envGymDesc => 'Machines, dumbbells and cardio equipment.';

  @override
  String get setupExtras => 'Customise (optional)';

  @override
  String get setupExtrasHint => 'Leave these as they are if you\'re not sure.';

  @override
  String get setupLevel => 'Fitness level';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get setupMinutes => 'Minutes per workout';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get setupEquipment => 'Equipment at home';

  @override
  String get equipDumbbells => 'Dumbbells';

  @override
  String get equipBands => 'Resistance bands';

  @override
  String get setupLimitations => 'Go easy on';

  @override
  String get setupLimitationsHint =>
      'Exercises that load these areas are left out.';

  @override
  String get limitKnees => 'Knees';

  @override
  String get limitLowerBack => 'Lower back';

  @override
  String get limitShoulders => 'Shoulders';

  @override
  String get limitWrists => 'Wrists';

  @override
  String get setupSafety =>
      'This is general fitness guidance, not medical advice. If you have a health condition or an injury, check with a doctor first, and stop any exercise that hurts.';

  @override
  String get createPlan => 'Create my plan';

  @override
  String get updatePlan => 'Update my plan';

  @override
  String get creatingPlan => 'Creating your plan…';

  @override
  String get regeneratePlan => 'Make a new plan';

  @override
  String get regenerateTitle => 'Make a new plan?';

  @override
  String get regenerateBody =>
      'Your current plan is replaced. Workouts you\'ve done stay in your history.';

  @override
  String get planMadeOffline =>
      'Made without AI because it couldn\'t be reached. Try again for a plan written for you by AI.';

  @override
  String get planTryAi => 'Try AI again';

  @override
  String get planOutdated =>
      'Your profile or setup changed since this plan was made.';

  @override
  String get planUpdate => 'Update plan';

  @override
  String get todaysWorkout => 'Today\'s workout';

  @override
  String progressDone(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get statExercises => 'Exercises';

  @override
  String get statDone => 'Done';

  @override
  String get statLeft => 'Left';

  @override
  String get statTime => 'Minutes';

  @override
  String get statKcal => 'Est. kcal';

  @override
  String aboutMinutes(int minutes) {
    return '≈ $minutes min';
  }

  @override
  String aboutKcal(int kcal) {
    return '≈ $kcal kcal';
  }

  @override
  String setsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String repsCount(int count) {
    return '$count reps';
  }

  @override
  String secondsShort(int seconds) {
    return '$seconds s';
  }

  @override
  String setsTimesReps(int sets, String reps) {
    return '$sets × $reps';
  }

  @override
  String get statusNotStarted => 'Not started';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Done';

  @override
  String get kcalDisclaimer =>
      'Calories are rough estimates (often off by 30% or more). Fat loss depends on your overall eating and activity over weeks, not on single exercises.';

  @override
  String exerciseCardLabel(String name, String detail, String status) {
    return '$name: $detail, $status';
  }

  @override
  String get workoutSetupTooltip => 'Workout setup';

  @override
  String get startingPosition => 'Starting position';

  @override
  String get howToDoIt => 'How to do it';

  @override
  String get formTip => 'Form tip';

  @override
  String get musclesWorked => 'Muscles worked';

  @override
  String get benefitsTitle => 'Benefits';

  @override
  String get whyInPlan => 'Why it\'s in your plan';

  @override
  String get statSets => 'Sets';

  @override
  String get statReps => 'Reps';

  @override
  String get statHold => 'Time';

  @override
  String get statRest => 'Rest';

  @override
  String kcalForExercise(int kcal) {
    return '≈ $kcal kcal for this exercise';
  }

  @override
  String get kcalInfoTitle => 'How calories are estimated';

  @override
  String kcalInfoMethod(String met, String weight, String time) {
    return 'We use the exercise\'s effort level (MET $met), your weight ($weight) and the active time ($time), and count only the calories above what you\'d burn resting. Rest between sets isn\'t counted. Age and gender aren\'t part of this method.';
  }

  @override
  String get kcalInfoUncertainty =>
      'Real calories vary with effort, pace and your body, often by 30% or more, so treat this as a rough guide.';

  @override
  String get kcalInfoFat =>
      'Fat loss comes from your overall eating and activity over weeks. No single exercise burns fat from one part of the body.';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String demoLabel(String name) {
    return 'Demonstration of $name';
  }

  @override
  String get demoPause => 'Pause demonstration';

  @override
  String get demoPlay => 'Play demonstration';

  @override
  String stepNumber(int number) {
    return 'Step $number';
  }

  @override
  String get exerciseNotFound => 'This exercise isn\'t available.';

  @override
  String get kcalInfoTooltip => 'How calories are estimated';
}
