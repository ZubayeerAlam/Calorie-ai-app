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
  String get exercisePlaceholder =>
      'Your personalised workout plan will appear here.';

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
}
