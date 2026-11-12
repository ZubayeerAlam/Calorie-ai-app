import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @nothingToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Nothing to analyse. Please go back.'**
  String get nothingToAnalyze;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @kcalValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kcal'**
  String kcalValue(String value);

  /// No description provided for @gramsValue.
  ///
  /// In en, this message translates to:
  /// **'{value} g'**
  String gramsValue(String value);

  /// No description provided for @kgValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String kgValue(String value);

  /// No description provided for @lbValue.
  ///
  /// In en, this message translates to:
  /// **'{value} lb'**
  String lbValue(String value);

  /// No description provided for @cmValue.
  ///
  /// In en, this message translates to:
  /// **'{value} cm'**
  String cmValue(String value);

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitFt.
  ///
  /// In en, this message translates to:
  /// **'ft'**
  String get unitFt;

  /// No description provided for @unitIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get unitIn;

  /// No description provided for @unitKcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get unitKcal;

  /// No description provided for @unitGrams.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitGrams;

  /// No description provided for @eatenOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{eaten} / {target} kcal'**
  String eatenOfTarget(String eaten, String target);

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(String value);

  /// No description provided for @todayDate.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String todayDate(String date);

  /// No description provided for @yesterdayDate.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {date}'**
  String yesterdayDate(String date);

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That email address doesn\'t look right.'**
  String get authInvalidEmail;

  /// No description provided for @authWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get authWrongCredentials;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Sign in instead.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Use a password of at least 6 characters.'**
  String get authWeakPassword;

  /// No description provided for @authNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get authNetwork;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment and try again.'**
  String get authTooManyRequests;

  /// No description provided for @authNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Email sign-in isn\'t turned on for this app yet.'**
  String get authNotEnabled;

  /// No description provided for @authUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authUnknown;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @backupUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Your backup couldn\'t be reached, so you weren\'t signed in. Check your connection and try again.'**
  String get backupUnreachable;

  /// No description provided for @enterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter your email first.'**
  String get enterEmailFirst;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to {email}'**
  String passwordResetSent(String email);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInIntro.
  ///
  /// In en, this message translates to:
  /// **'Back up your meals, weight and goals, and use them on another phone. The data already on this phone is kept and added to your account.'**
  String get signInIntro;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordHelper;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccountSignIn;

  /// No description provided for @newHereCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get newHereCreateAccount;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutTitle;

  /// No description provided for @logOutBody.
  ///
  /// In en, this message translates to:
  /// **'Your data stays in your account and is removed from this phone. Sign in again to get it back.'**
  String get logOutBody;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @backUpYourData.
  ///
  /// In en, this message translates to:
  /// **'Back up your data'**
  String get backUpYourData;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @backUpPitch.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your meals and weight safe and use them on another phone.'**
  String get backUpPitch;

  /// No description provided for @backedUpSynced.
  ///
  /// In en, this message translates to:
  /// **'Backed up and synced to your account'**
  String get backedUpSynced;

  /// No description provided for @signInOrCreate.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create account'**
  String get signInOrCreate;

  /// No description provided for @healthAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access wasn\'t allowed. You can allow it in {app} settings.'**
  String healthAccessDenied(String app);

  /// No description provided for @healthInstall.
  ///
  /// In en, this message translates to:
  /// **'Install or update {app} to import your steps and workouts.'**
  String healthInstall(String app);

  /// No description provided for @install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// No description provided for @healthImporting.
  ///
  /// In en, this message translates to:
  /// **'Steps and workout calories are imported automatically.'**
  String get healthImporting;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @healthPitch.
  ///
  /// In en, this message translates to:
  /// **'Import all your steps (also those walked before opening the app) and the calories from your workouts.'**
  String get healthPitch;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @healthConnected.
  ///
  /// In en, this message translates to:
  /// **'{app} connected'**
  String healthConnected(String app);

  /// No description provided for @stepsCount.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps'**
  String stepsCount(String steps);

  /// No description provided for @allowStepAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow step access'**
  String get allowStepAccess;

  /// No description provided for @noStepSensor.
  ///
  /// In en, this message translates to:
  /// **'No step sensor'**
  String get noStepSensor;

  /// No description provided for @dailyGoalKcal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal: {kcal} kcal'**
  String dailyGoalKcal(String kcal);

  /// No description provided for @goalKcalADay.
  ///
  /// In en, this message translates to:
  /// **'{goal} · {kcal} kcal a day'**
  String goalKcalADay(String goal, String kcal);

  /// No description provided for @eaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get eaten;

  /// No description provided for @burned.
  ///
  /// In en, this message translates to:
  /// **'Burned'**
  String get burned;

  /// No description provided for @walking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @logActivity.
  ///
  /// In en, this message translates to:
  /// **'Log activity'**
  String get logActivity;

  /// No description provided for @kcalOver.
  ///
  /// In en, this message translates to:
  /// **'kcal over'**
  String get kcalOver;

  /// No description provided for @kcalLeft.
  ///
  /// In en, this message translates to:
  /// **'kcal left'**
  String get kcalLeft;

  /// No description provided for @yourCaloriePlan.
  ///
  /// In en, this message translates to:
  /// **'Your calorie plan'**
  String get yourCaloriePlan;

  /// No description provided for @caloriesAtRest.
  ///
  /// In en, this message translates to:
  /// **'Calories at rest (BMR)'**
  String get caloriesAtRest;

  /// No description provided for @withActivity.
  ///
  /// In en, this message translates to:
  /// **'With activity × {factor}'**
  String withActivity(String factor);

  /// No description provided for @goalAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Goal adjustment'**
  String get goalAdjustment;

  /// No description provided for @recommendedDailyTarget.
  ///
  /// In en, this message translates to:
  /// **'Recommended daily target'**
  String get recommendedDailyTarget;

  /// No description provided for @raisedToMinimum.
  ///
  /// In en, this message translates to:
  /// **'Raised to the {kcal} kcal minimum'**
  String raisedToMinimum(String kcal);

  /// No description provided for @yourCustomTarget.
  ///
  /// In en, this message translates to:
  /// **'Your custom target'**
  String get yourCustomTarget;

  /// No description provided for @setOnAccount.
  ///
  /// In en, this message translates to:
  /// **'Set on Account'**
  String get setOnAccount;

  /// No description provided for @macros.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get macros;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @macroShare.
  ///
  /// In en, this message translates to:
  /// **'{percent} · {kcal} kcal/g'**
  String macroShare(String percent, String kcal);

  /// No description provided for @previousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseDate;

  /// No description provided for @emptyToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet today. Tap ＋ on a meal to log food.'**
  String get emptyToday;

  /// No description provided for @emptyDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged on this day. Tap ＋ on a meal to add it.'**
  String get emptyDay;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @greetingName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingName(String greeting, String name);

  /// No description provided for @activitySheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calories burned from exercise · {day}'**
  String activitySheetSubtitle(String day);

  /// No description provided for @plusHealthWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Plus {kcal} kcal from workouts in Health'**
  String plusHealthWorkouts(String kcal);

  /// No description provided for @nothingLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet'**
  String get nothingLoggedYet;

  /// No description provided for @addToMeal.
  ///
  /// In en, this message translates to:
  /// **'Add to {meal}'**
  String addToMeal(String meal);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @keepWeightSteady.
  ///
  /// In en, this message translates to:
  /// **'Keep your weight steady'**
  String get keepWeightSteady;

  /// No description provided for @kgPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{value} kg / week'**
  String kgPerWeek(String value);

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get enterNumber;

  /// No description provided for @addFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFoodTitle;

  /// No description provided for @scanPhoto.
  ///
  /// In en, this message translates to:
  /// **'Scan a photo'**
  String get scanPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @foodName.
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get foodName;

  /// No description provided for @caloriesKcal.
  ///
  /// In en, this message translates to:
  /// **'Calories (kcal)'**
  String get caloriesKcal;

  /// No description provided for @enterWholeCalories.
  ///
  /// In en, this message translates to:
  /// **'Enter whole calories'**
  String get enterWholeCalories;

  /// No description provided for @macrosBlankHint.
  ///
  /// In en, this message translates to:
  /// **'Leave protein, carbs and fat blank to estimate them from calories.'**
  String get macrosBlankHint;

  /// No description provided for @proteinG.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get proteinG;

  /// No description provided for @carbsG.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get carbsG;

  /// No description provided for @fatG.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get fatG;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @whatDidYouEat.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get whatDidYouEat;

  /// No description provided for @manualIntro.
  ///
  /// In en, this message translates to:
  /// **'Describe your meal and the AI will estimate calories and macros. List several foods with commas.'**
  String get manualIntro;

  /// No description provided for @yourMeal.
  ///
  /// In en, this message translates to:
  /// **'Your meal'**
  String get yourMeal;

  /// No description provided for @yourMealHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 scrambled eggs, toast with butter, black coffee'**
  String get yourMealHint;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details (optional)'**
  String get moreDetails;

  /// No description provided for @moreDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'These help the estimate be more accurate.'**
  String get moreDetailsHint;

  /// No description provided for @portionSize.
  ///
  /// In en, this message translates to:
  /// **'Portion size'**
  String get portionSize;

  /// No description provided for @portionSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1 large plate, 250 g'**
  String get portionSizeHint;

  /// No description provided for @cookingMethod.
  ///
  /// In en, this message translates to:
  /// **'Cooking method'**
  String get cookingMethod;

  /// No description provided for @cookingMethodHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. fried in oil, grilled, boiled'**
  String get cookingMethodHint;

  /// No description provided for @brandOrRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Brand or restaurant'**
  String get brandOrRestaurant;

  /// No description provided for @brandHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Starbucks, Nestlé'**
  String get brandHint;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @ingredientsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. olive oil, cheese, sugar'**
  String get ingredientsHint;

  /// No description provided for @enterNumbersMyself.
  ///
  /// In en, this message translates to:
  /// **'Enter numbers myself'**
  String get enterNumbersMyself;

  /// No description provided for @analyzeWithAi.
  ///
  /// In en, this message translates to:
  /// **'Analyze with AI'**
  String get analyzeWithAi;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get addFood;

  /// No description provided for @howToAddMeal.
  ///
  /// In en, this message translates to:
  /// **'How would you like to add your meal?'**
  String get howToAddMeal;

  /// No description provided for @scanWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get scanWithCamera;

  /// No description provided for @scanWithCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Take or choose a photo of your meal'**
  String get scanWithCameraHint;

  /// No description provided for @addManuallyHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your meal and get its nutrition'**
  String get addManuallyHint;

  /// No description provided for @addFoodWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Add food with camera'**
  String get addFoodWithCamera;

  /// No description provided for @aiEstimateTag.
  ///
  /// In en, this message translates to:
  /// **'(AI estimate)'**
  String get aiEstimateTag;

  /// No description provided for @estimatedTag.
  ///
  /// In en, this message translates to:
  /// **'(est.)'**
  String get estimatedTag;

  /// No description provided for @macroShort.
  ///
  /// In en, this message translates to:
  /// **'P {protein}g C {carbs}g F {fat}g'**
  String macroShort(String protein, String carbs, String fat);

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String deleteEntry(String name);

  /// No description provided for @detailPortion.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get detailPortion;

  /// No description provided for @detailCooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get detailCooking;

  /// No description provided for @detailBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get detailBrand;

  /// No description provided for @detailIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get detailIngredients;

  /// No description provided for @addedItemsToMeal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added 1 item to {meal}} other{Added {count} items to {meal}}}'**
  String addedItemsToMeal(int count, String meal);

  /// No description provided for @scanFood.
  ///
  /// In en, this message translates to:
  /// **'Scan Food'**
  String get scanFood;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @useThisPhoto.
  ///
  /// In en, this message translates to:
  /// **'Use this photo'**
  String get useThisPhoto;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan food.'**
  String get cameraPermissionRequired;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @imageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the image. Please try again.'**
  String get imageLoadFailed;

  /// No description provided for @noFoodFound.
  ///
  /// In en, this message translates to:
  /// **'No food found'**
  String get noFoodFound;

  /// No description provided for @noFoodFoundPhoto.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t spot any food in this photo. Try another photo, or enter the food yourself.'**
  String get noFoodFoundPhoto;

  /// No description provided for @noFoodRecognised.
  ///
  /// In en, this message translates to:
  /// **'No food recognised'**
  String get noFoodRecognised;

  /// No description provided for @noFoodRecognisedText.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any food in what you wrote. Try describing it differently, or enter the numbers yourself.'**
  String get noFoodRecognisedText;

  /// No description provided for @cantReachAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the analysis service'**
  String get cantReachAnalysis;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'The analysis didn\'t work this time. Try again, or enter the food yourself.'**
  String get analysisFailed;

  /// No description provided for @tryAnotherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Try another photo'**
  String get tryAnotherPhoto;

  /// No description provided for @editDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit description'**
  String get editDescription;

  /// No description provided for @enterItManually.
  ///
  /// In en, this message translates to:
  /// **'Enter it manually'**
  String get enterItManually;

  /// No description provided for @analyzingMeal.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your meal…'**
  String get analyzingMeal;

  /// No description provided for @takesFewSeconds.
  ///
  /// In en, this message translates to:
  /// **'This usually takes a few seconds.'**
  String get takesFewSeconds;

  /// No description provided for @allItemsRemoved.
  ///
  /// In en, this message translates to:
  /// **'All items removed'**
  String get allItemsRemoved;

  /// No description provided for @weFoundItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{We found 1 item} other{We found {count} items}}'**
  String weFoundItems(int count);

  /// No description provided for @goBackAnotherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Go back to try another photo.'**
  String get goBackAnotherPhoto;

  /// No description provided for @goBackEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Go back to edit your description.'**
  String get goBackEditDescription;

  /// No description provided for @aiEstimateCheck.
  ///
  /// In en, this message translates to:
  /// **'AI estimate · check and edit before saving'**
  String get aiEstimateCheck;

  /// No description provided for @addTo.
  ///
  /// In en, this message translates to:
  /// **'Add to'**
  String get addTo;

  /// No description provided for @addToMealKcal.
  ///
  /// In en, this message translates to:
  /// **'Add to {meal} · {kcal} kcal'**
  String addToMealKcal(String meal, String kcal);

  /// No description provided for @addAName.
  ///
  /// In en, this message translates to:
  /// **'Add a name'**
  String get addAName;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String removeItem(String name);

  /// No description provided for @portion.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get portion;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @demoPhoto.
  ///
  /// In en, this message translates to:
  /// **'Demo result: AI analysis isn\'t connected yet, so these are sample foods, not what\'s in your photo. Edit them before saving.'**
  String get demoPhoto;

  /// No description provided for @demoText.
  ///
  /// In en, this message translates to:
  /// **'Demo result: AI analysis isn\'t connected yet, so these are sample numbers, not real nutrition for what you typed. Edit them before saving.'**
  String get demoText;

  /// No description provided for @youDescribed.
  ///
  /// In en, this message translates to:
  /// **'You described'**
  String get youDescribed;

  /// No description provided for @detailLine.
  ///
  /// In en, this message translates to:
  /// **'{label}: '**
  String detailLine(String label);

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabTracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tabTracker;

  /// No description provided for @tabExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get tabExercise;

  /// No description provided for @tabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get tabAccount;

  /// No description provided for @howActive.
  ///
  /// In en, this message translates to:
  /// **'How active are you?'**
  String get howActive;

  /// No description provided for @whenBorn.
  ///
  /// In en, this message translates to:
  /// **'When were you born?'**
  String get whenBorn;

  /// No description provided for @ageRange.
  ///
  /// In en, this message translates to:
  /// **'You must be between {min} and {max} years old.'**
  String ageRange(String min, String max);

  /// No description provided for @specificDiet.
  ///
  /// In en, this message translates to:
  /// **'Do you follow a specific diet?'**
  String get specificDiet;

  /// No description provided for @whenDinner.
  ///
  /// In en, this message translates to:
  /// **'When do you usually have\ndinner?'**
  String get whenDinner;

  /// No description provided for @chooseGender.
  ///
  /// In en, this message translates to:
  /// **'Choose your gender'**
  String get chooseGender;

  /// No description provided for @mainGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your main goal?'**
  String get mainGoal;

  /// No description provided for @howTall.
  ///
  /// In en, this message translates to:
  /// **'How tall are you?'**
  String get howTall;

  /// No description provided for @ftIn.
  ///
  /// In en, this message translates to:
  /// **'ft / in'**
  String get ftIn;

  /// No description provided for @whatsYourName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get whatsYourName;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @personalizing.
  ///
  /// In en, this message translates to:
  /// **'Personalizing your {app}\nexperience...'**
  String personalizing(String app);

  /// No description provided for @hangTight.
  ///
  /// In en, this message translates to:
  /// **'Hang tight! We\'re crafting a personalized plan just for you.'**
  String get hangTight;

  /// No description provided for @planReady.
  ///
  /// In en, this message translates to:
  /// **'Your plan is ready'**
  String get planReady;

  /// No description provided for @caloriesPerDay.
  ///
  /// In en, this message translates to:
  /// **'calories per day'**
  String get caloriesPerDay;

  /// No description provided for @kgPerWeekSigned.
  ///
  /// In en, this message translates to:
  /// **'{value} kg per week'**
  String kgPerWeekSigned(String value);

  /// No description provided for @whatsYourWeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your weight?'**
  String get whatsYourWeight;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'{step} / {total}'**
  String stepOf(String step, String total);

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @goalLose.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get goalLose;

  /// No description provided for @goalMaintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain weight'**
  String get goalMaintain;

  /// No description provided for @goalGain.
  ///
  /// In en, this message translates to:
  /// **'Gain weight'**
  String get goalGain;

  /// No description provided for @focusGainMuscle.
  ///
  /// In en, this message translates to:
  /// **'Gain muscle'**
  String get focusGainMuscle;

  /// No description provided for @focusBoostEnergy.
  ///
  /// In en, this message translates to:
  /// **'Boost energy'**
  String get focusBoostEnergy;

  /// No description provided for @focusImproveNutrition.
  ///
  /// In en, this message translates to:
  /// **'Improve nutrition'**
  String get focusImproveNutrition;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get activitySedentary;

  /// No description provided for @activityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly active'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get activityModerate;

  /// No description provided for @activityActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get activityActive;

  /// No description provided for @activitySedentaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Little or no exercise, desk job'**
  String get activitySedentaryDesc;

  /// No description provided for @activityLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Light exercise 1–3 days a week'**
  String get activityLightDesc;

  /// No description provided for @activityModerateDesc.
  ///
  /// In en, this message translates to:
  /// **'Moderate exercise 3–5 days a week'**
  String get activityModerateDesc;

  /// No description provided for @activityActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Hard exercise 6–7 days a week'**
  String get activityActiveDesc;

  /// No description provided for @dietClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get dietClassic;

  /// No description provided for @dietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietPescatarian.
  ///
  /// In en, this message translates to:
  /// **'Pescatarian'**
  String get dietPescatarian;

  /// No description provided for @dietKeto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get dietKeto;

  /// No description provided for @dietClassicDesc.
  ///
  /// In en, this message translates to:
  /// **'No restrictions'**
  String get dietClassicDesc;

  /// No description provided for @dietVegetarianDesc.
  ///
  /// In en, this message translates to:
  /// **'No meat or fish'**
  String get dietVegetarianDesc;

  /// No description provided for @dietVeganDesc.
  ///
  /// In en, this message translates to:
  /// **'No animal products'**
  String get dietVeganDesc;

  /// No description provided for @dietPescatarianDesc.
  ///
  /// In en, this message translates to:
  /// **'Fish but no meat'**
  String get dietPescatarianDesc;

  /// No description provided for @dietKetoDesc.
  ///
  /// In en, this message translates to:
  /// **'High fat, very low carb'**
  String get dietKetoDesc;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get bmiHealthy;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObese;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @usualDinnerTime.
  ///
  /// In en, this message translates to:
  /// **'Usual dinner time'**
  String get usualDinnerTime;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @unitsMetric.
  ///
  /// In en, this message translates to:
  /// **'kg · cm'**
  String get unitsMetric;

  /// No description provided for @unitsImperial.
  ///
  /// In en, this message translates to:
  /// **'lb · ft'**
  String get unitsImperial;

  /// No description provided for @logWeightOnTracker.
  ///
  /// In en, this message translates to:
  /// **'Log a new weight on the Tracker tab.'**
  String get logWeightOnTracker;

  /// No description provided for @ageValue.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String ageValue(String age);

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @weightGoal.
  ///
  /// In en, this message translates to:
  /// **'Weight goal'**
  String get weightGoal;

  /// No description provided for @weightGoalHint.
  ///
  /// In en, this message translates to:
  /// **'This sets your calorie target.'**
  String get weightGoalHint;

  /// No description provided for @alsoFocusOn.
  ///
  /// In en, this message translates to:
  /// **'Also focus on'**
  String get alsoFocusOn;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get activityLevel;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @heightRangeError.
  ///
  /// In en, this message translates to:
  /// **'Enter a height between 100 and 250 cm (3′4″–8′2″)'**
  String get heightRangeError;

  /// No description provided for @profileAndGoals.
  ///
  /// In en, this message translates to:
  /// **'Profile & Goals'**
  String get profileAndGoals;

  /// No description provided for @dailyCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie goal: {kcal} kcal'**
  String dailyCalorieGoal(String kcal);

  /// No description provided for @customRecommended.
  ///
  /// In en, this message translates to:
  /// **'Custom · recommended {kcal} kcal'**
  String customRecommended(String kcal);

  /// No description provided for @recommendedForProfile.
  ///
  /// In en, this message translates to:
  /// **'Recommended for your profile'**
  String get recommendedForProfile;

  /// No description provided for @resetToRecommended.
  ///
  /// In en, this message translates to:
  /// **'Reset to recommended'**
  String get resetToRecommended;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @profileSummary.
  ///
  /// In en, this message translates to:
  /// **'{age} years · {height} · {weight}\n{goal} · {activity}'**
  String profileSummary(
    String age,
    String height,
    String weight,
    String goal,
    String activity,
  );

  /// No description provided for @resetAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get resetAllDataTitle;

  /// No description provided for @resetSignedIn.
  ///
  /// In en, this message translates to:
  /// **'This deletes your profile, meals, weight and activity from this phone and from your account, and starts again with setup. You\'ll stay signed in. This can\'t be undone.'**
  String get resetSignedIn;

  /// No description provided for @resetLocal.
  ///
  /// In en, this message translates to:
  /// **'This deletes your profile, meals, weight and activity from this phone and starts again with setup. This can\'t be undone.'**
  String get resetLocal;

  /// No description provided for @deleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get deleteEverything;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get resetAllData;

  /// No description provided for @notificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Cal AI. Allow them in your phone\'s settings to get reminders.'**
  String get notificationsOff;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @remindersIntro.
  ///
  /// In en, this message translates to:
  /// **'Turn on a reminder and Cal AI will nudge you to log your meals. A reminder is skipped once that meal is logged.'**
  String get remindersIntro;

  /// No description provided for @mealReminders.
  ///
  /// In en, this message translates to:
  /// **'Meal reminders'**
  String get mealReminders;

  /// No description provided for @mealRemindersChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders to log breakfast, lunch and dinner'**
  String get mealRemindersChannelDesc;

  /// No description provided for @dinnerTimeFromProfile.
  ///
  /// In en, this message translates to:
  /// **'Your dinner time from your profile'**
  String get dinnerTimeFromProfile;

  /// No description provided for @mealReminder.
  ///
  /// In en, this message translates to:
  /// **'{meal} reminder'**
  String mealReminder(String meal);

  /// No description provided for @logged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get logged;

  /// No description provided for @reminderAt.
  ///
  /// In en, this message translates to:
  /// **'Reminder at {time}'**
  String reminderAt(String time);

  /// No description provided for @notLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'Not logged yet · {time}'**
  String notLoggedYet(String time);

  /// No description provided for @logNow.
  ///
  /// In en, this message translates to:
  /// **'Log now'**
  String get logNow;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Log what you eat to stay on track today.'**
  String get reminderBody;

  /// No description provided for @reminderBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Time for breakfast'**
  String get reminderBreakfast;

  /// No description provided for @reminderLunch.
  ///
  /// In en, this message translates to:
  /// **'Time for lunch'**
  String get reminderLunch;

  /// No description provided for @reminderDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner time'**
  String get reminderDinner;

  /// No description provided for @reminderSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack time'**
  String get reminderSnack;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @tracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tracker;

  /// No description provided for @targetDashedLine.
  ///
  /// In en, this message translates to:
  /// **'Target {kcal} kcal · dashed line'**
  String targetDashedLine(String kcal);

  /// No description provided for @onTarget.
  ///
  /// In en, this message translates to:
  /// **'On target'**
  String get onTarget;

  /// No description provided for @under.
  ///
  /// In en, this message translates to:
  /// **'Under'**
  String get under;

  /// No description provided for @over.
  ///
  /// In en, this message translates to:
  /// **'Over'**
  String get over;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @nothingInPeriod.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged in this period yet'**
  String get nothingInPeriod;

  /// No description provided for @tapDayToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to open it on Home'**
  String get tapDayToOpen;

  /// No description provided for @historyMacros.
  ///
  /// In en, this message translates to:
  /// **'P {protein} g · C {carbs} g · F {fat} g'**
  String historyMacros(String protein, String carbs, String fat);

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get logWeight;

  /// No description provided for @logWeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s weight. Your calorie target follows it.'**
  String get logWeightSubtitle;

  /// No description provided for @realisticWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a realistic weight'**
  String get realisticWeight;

  /// No description provided for @dailyAverageLogged.
  ///
  /// In en, this message translates to:
  /// **'Daily average on logged days'**
  String get dailyAverageLogged;

  /// No description provided for @gramsOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{value} / {target} g'**
  String gramsOfTarget(String value, String target);

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @noStepsYet.
  ///
  /// In en, this message translates to:
  /// **'No steps counted yet'**
  String get noStepsYet;

  /// No description provided for @stepsAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg {avg} a day · {total} total'**
  String stepsAverage(String avg, String total);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get dayStreak;

  /// No description provided for @avgKcalDay.
  ///
  /// In en, this message translates to:
  /// **'avg kcal / day'**
  String get avgKcalDay;

  /// No description provided for @daysOnTarget.
  ///
  /// In en, this message translates to:
  /// **'days on target'**
  String get daysOnTarget;

  /// No description provided for @logWeightTrend.
  ///
  /// In en, this message translates to:
  /// **'Log your weight to see the trend'**
  String get logWeightTrend;

  /// No description provided for @changeInPeriod.
  ///
  /// In en, this message translates to:
  /// **'{change} in this period'**
  String changeInPeriod(String change);

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get log;

  /// No description provided for @exPushUpName.
  ///
  /// In en, this message translates to:
  /// **'Push-up'**
  String get exPushUpName;

  /// No description provided for @exPushUpPosition.
  ///
  /// In en, this message translates to:
  /// **'Hands under your shoulders, body in a straight line from head to heels.'**
  String get exPushUpPosition;

  /// No description provided for @exPushUpStep1.
  ///
  /// In en, this message translates to:
  /// **'Start at the top with your arms straight.'**
  String get exPushUpStep1;

  /// No description provided for @exPushUpStep2.
  ///
  /// In en, this message translates to:
  /// **'Bend your elbows and lower your chest to just above the floor.'**
  String get exPushUpStep2;

  /// No description provided for @exPushUpStep3.
  ///
  /// In en, this message translates to:
  /// **'Push the floor away until your arms are straight again.'**
  String get exPushUpStep3;

  /// No description provided for @exPushUpTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your hips level; don\'t let them sag or lift.'**
  String get exPushUpTip;

  /// No description provided for @exPushUpBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds upper-body strength and endurance.'**
  String get exPushUpBenefit;

  /// No description provided for @exKneePushUpName.
  ///
  /// In en, this message translates to:
  /// **'Knee push-up'**
  String get exKneePushUpName;

  /// No description provided for @exKneePushUpPosition.
  ///
  /// In en, this message translates to:
  /// **'Knees on the floor, hands under your shoulders, body straight from head to knees.'**
  String get exKneePushUpPosition;

  /// No description provided for @exKneePushUpStep1.
  ///
  /// In en, this message translates to:
  /// **'Start with your arms straight.'**
  String get exKneePushUpStep1;

  /// No description provided for @exKneePushUpStep2.
  ///
  /// In en, this message translates to:
  /// **'Lower your chest towards the floor.'**
  String get exKneePushUpStep2;

  /// No description provided for @exKneePushUpStep3.
  ///
  /// In en, this message translates to:
  /// **'Push back up until your arms are straight.'**
  String get exKneePushUpStep3;

  /// No description provided for @exKneePushUpTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your stomach tight so your back stays flat.'**
  String get exKneePushUpTip;

  /// No description provided for @exKneePushUpBenefit.
  ///
  /// In en, this message translates to:
  /// **'An easier push-up that builds chest and arm strength.'**
  String get exKneePushUpBenefit;

  /// No description provided for @exInclinePushUpName.
  ///
  /// In en, this message translates to:
  /// **'Incline push-up'**
  String get exInclinePushUpName;

  /// No description provided for @exInclinePushUpPosition.
  ///
  /// In en, this message translates to:
  /// **'Hands on a sturdy table or chair edge, feet back, body in a straight line.'**
  String get exInclinePushUpPosition;

  /// No description provided for @exInclinePushUpStep1.
  ///
  /// In en, this message translates to:
  /// **'Start with your arms straight.'**
  String get exInclinePushUpStep1;

  /// No description provided for @exInclinePushUpStep2.
  ///
  /// In en, this message translates to:
  /// **'Bend your elbows to bring your chest to the edge.'**
  String get exInclinePushUpStep2;

  /// No description provided for @exInclinePushUpStep3.
  ///
  /// In en, this message translates to:
  /// **'Push back until your arms are straight.'**
  String get exInclinePushUpStep3;

  /// No description provided for @exInclinePushUpTip.
  ///
  /// In en, this message translates to:
  /// **'Make sure the chair or table can\'t slide.'**
  String get exInclinePushUpTip;

  /// No description provided for @exInclinePushUpBenefit.
  ///
  /// In en, this message translates to:
  /// **'An easier push-up for building up to the full one.'**
  String get exInclinePushUpBenefit;

  /// No description provided for @exSquatName.
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get exSquatName;

  /// No description provided for @exSquatPosition.
  ///
  /// In en, this message translates to:
  /// **'Feet shoulder-width apart, toes slightly out, chest up.'**
  String get exSquatPosition;

  /// No description provided for @exSquatStep1.
  ///
  /// In en, this message translates to:
  /// **'Stand tall with your weight on your heels.'**
  String get exSquatStep1;

  /// No description provided for @exSquatStep2.
  ///
  /// In en, this message translates to:
  /// **'Push your hips back and bend your knees as if sitting on a chair.'**
  String get exSquatStep2;

  /// No description provided for @exSquatStep3.
  ///
  /// In en, this message translates to:
  /// **'Push through your heels to stand back up.'**
  String get exSquatStep3;

  /// No description provided for @exSquatTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees in line with your toes.'**
  String get exSquatTip;

  /// No description provided for @exSquatBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens legs and glutes for everyday movement.'**
  String get exSquatBenefit;

  /// No description provided for @exLungeName.
  ///
  /// In en, this message translates to:
  /// **'Lunge'**
  String get exLungeName;

  /// No description provided for @exLungePosition.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, feet hip-width apart, hands on your hips.'**
  String get exLungePosition;

  /// No description provided for @exLungeStep1.
  ///
  /// In en, this message translates to:
  /// **'Take a big step forward.'**
  String get exLungeStep1;

  /// No description provided for @exLungeStep2.
  ///
  /// In en, this message translates to:
  /// **'Lower until both knees are bent at about 90°.'**
  String get exLungeStep2;

  /// No description provided for @exLungeStep3.
  ///
  /// In en, this message translates to:
  /// **'Push off the front foot back to standing; switch legs.'**
  String get exLungeStep3;

  /// No description provided for @exLungeTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your front knee over your ankle, not past your toes.'**
  String get exLungeTip;

  /// No description provided for @exLungeBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds leg strength and balance, one leg at a time.'**
  String get exLungeBenefit;

  /// No description provided for @exGluteBridgeName.
  ///
  /// In en, this message translates to:
  /// **'Glute bridge'**
  String get exGluteBridgeName;

  /// No description provided for @exGluteBridgePosition.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, knees bent, feet flat and hip-width apart.'**
  String get exGluteBridgePosition;

  /// No description provided for @exGluteBridgeStep1.
  ///
  /// In en, this message translates to:
  /// **'Rest your arms by your sides.'**
  String get exGluteBridgeStep1;

  /// No description provided for @exGluteBridgeStep2.
  ///
  /// In en, this message translates to:
  /// **'Squeeze your glutes and lift your hips until your body is straight from knees to shoulders.'**
  String get exGluteBridgeStep2;

  /// No description provided for @exGluteBridgeStep3.
  ///
  /// In en, this message translates to:
  /// **'Lower your hips slowly back down.'**
  String get exGluteBridgeStep3;

  /// No description provided for @exGluteBridgeTip.
  ///
  /// In en, this message translates to:
  /// **'Push through your heels and don\'t arch your lower back.'**
  String get exGluteBridgeTip;

  /// No description provided for @exGluteBridgeBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens glutes and the back of the legs; kind to the knees.'**
  String get exGluteBridgeBenefit;

  /// No description provided for @exPlankName.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get exPlankName;

  /// No description provided for @exPlankPosition.
  ///
  /// In en, this message translates to:
  /// **'Forearms on the floor under your shoulders, legs straight behind you.'**
  String get exPlankPosition;

  /// No description provided for @exPlankStep1.
  ///
  /// In en, this message translates to:
  /// **'Lift your body so it forms a straight line from head to heels.'**
  String get exPlankStep1;

  /// No description provided for @exPlankStep2.
  ///
  /// In en, this message translates to:
  /// **'Tighten your stomach and glutes.'**
  String get exPlankStep2;

  /// No description provided for @exPlankStep3.
  ///
  /// In en, this message translates to:
  /// **'Hold the position and keep breathing.'**
  String get exPlankStep3;

  /// No description provided for @exPlankTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let your hips drop or rise.'**
  String get exPlankTip;

  /// No description provided for @exPlankBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds core strength that supports your back.'**
  String get exPlankBenefit;

  /// No description provided for @exSidePlankName.
  ///
  /// In en, this message translates to:
  /// **'Side plank'**
  String get exSidePlankName;

  /// No description provided for @exSidePlankPosition.
  ///
  /// In en, this message translates to:
  /// **'Lie on your side, forearm under your shoulder, legs stacked.'**
  String get exSidePlankPosition;

  /// No description provided for @exSidePlankStep1.
  ///
  /// In en, this message translates to:
  /// **'Lift your hips so your body is straight.'**
  String get exSidePlankStep1;

  /// No description provided for @exSidePlankStep2.
  ///
  /// In en, this message translates to:
  /// **'Hold, keeping your hips high.'**
  String get exSidePlankStep2;

  /// No description provided for @exSidePlankStep3.
  ///
  /// In en, this message translates to:
  /// **'Lower slowly; switch sides.'**
  String get exSidePlankStep3;

  /// No description provided for @exSidePlankTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your elbow right under your shoulder.'**
  String get exSidePlankTip;

  /// No description provided for @exSidePlankBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the sides of your core and improves stability.'**
  String get exSidePlankBenefit;

  /// No description provided for @exMountainClimberName.
  ///
  /// In en, this message translates to:
  /// **'Mountain climber'**
  String get exMountainClimberName;

  /// No description provided for @exMountainClimberPosition.
  ///
  /// In en, this message translates to:
  /// **'High plank: hands under your shoulders, body straight.'**
  String get exMountainClimberPosition;

  /// No description provided for @exMountainClimberStep1.
  ///
  /// In en, this message translates to:
  /// **'Bring one knee towards your chest.'**
  String get exMountainClimberStep1;

  /// No description provided for @exMountainClimberStep2.
  ///
  /// In en, this message translates to:
  /// **'Switch legs quickly, like running in place.'**
  String get exMountainClimberStep2;

  /// No description provided for @exMountainClimberStep3.
  ///
  /// In en, this message translates to:
  /// **'Keep going at a steady pace for the set time.'**
  String get exMountainClimberStep3;

  /// No description provided for @exMountainClimberTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your hips low and your shoulders over your hands.'**
  String get exMountainClimberTip;

  /// No description provided for @exMountainClimberBenefit.
  ///
  /// In en, this message translates to:
  /// **'Raises your heart rate while working your core.'**
  String get exMountainClimberBenefit;

  /// No description provided for @exJumpingJackName.
  ///
  /// In en, this message translates to:
  /// **'Jumping jack'**
  String get exJumpingJackName;

  /// No description provided for @exJumpingJackPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand with feet together and arms by your sides.'**
  String get exJumpingJackPosition;

  /// No description provided for @exJumpingJackStep1.
  ///
  /// In en, this message translates to:
  /// **'Jump your feet apart while raising your arms overhead.'**
  String get exJumpingJackStep1;

  /// No description provided for @exJumpingJackStep2.
  ///
  /// In en, this message translates to:
  /// **'Jump back to the start.'**
  String get exJumpingJackStep2;

  /// No description provided for @exJumpingJackStep3.
  ///
  /// In en, this message translates to:
  /// **'Repeat at a steady rhythm for the set time.'**
  String get exJumpingJackStep3;

  /// No description provided for @exJumpingJackTip.
  ///
  /// In en, this message translates to:
  /// **'Land softly on the balls of your feet.'**
  String get exJumpingJackTip;

  /// No description provided for @exJumpingJackBenefit.
  ///
  /// In en, this message translates to:
  /// **'A simple cardio move that warms up the whole body.'**
  String get exJumpingJackBenefit;

  /// No description provided for @exHighKneesName.
  ///
  /// In en, this message translates to:
  /// **'High knees'**
  String get exHighKneesName;

  /// No description provided for @exHighKneesPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, feet hip-width apart.'**
  String get exHighKneesPosition;

  /// No description provided for @exHighKneesStep1.
  ///
  /// In en, this message translates to:
  /// **'Run in place, lifting one knee to hip height.'**
  String get exHighKneesStep1;

  /// No description provided for @exHighKneesStep2.
  ///
  /// In en, this message translates to:
  /// **'Switch legs quickly, pumping your arms.'**
  String get exHighKneesStep2;

  /// No description provided for @exHighKneesStep3.
  ///
  /// In en, this message translates to:
  /// **'Keep going for the set time.'**
  String get exHighKneesStep3;

  /// No description provided for @exHighKneesTip.
  ///
  /// In en, this message translates to:
  /// **'Stay on the balls of your feet and stand tall.'**
  String get exHighKneesTip;

  /// No description provided for @exHighKneesBenefit.
  ///
  /// In en, this message translates to:
  /// **'Raises your heart rate and works your legs.'**
  String get exHighKneesBenefit;

  /// No description provided for @exSupermanName.
  ///
  /// In en, this message translates to:
  /// **'Superman'**
  String get exSupermanName;

  /// No description provided for @exSupermanPosition.
  ///
  /// In en, this message translates to:
  /// **'Lie face down, arms stretched out in front, legs straight.'**
  String get exSupermanPosition;

  /// No description provided for @exSupermanStep1.
  ///
  /// In en, this message translates to:
  /// **'Look at the floor to keep your neck relaxed.'**
  String get exSupermanStep1;

  /// No description provided for @exSupermanStep2.
  ///
  /// In en, this message translates to:
  /// **'Lift your arms, chest and legs a little off the floor.'**
  String get exSupermanStep2;

  /// No description provided for @exSupermanStep3.
  ///
  /// In en, this message translates to:
  /// **'Hold for a moment, then lower slowly.'**
  String get exSupermanStep3;

  /// No description provided for @exSupermanTip.
  ///
  /// In en, this message translates to:
  /// **'Lift only a few centimetres; don\'t throw your head back.'**
  String get exSupermanTip;

  /// No description provided for @exSupermanBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the muscles along your back.'**
  String get exSupermanBenefit;

  /// No description provided for @exBirdDogName.
  ///
  /// In en, this message translates to:
  /// **'Bird dog'**
  String get exBirdDogName;

  /// No description provided for @exBirdDogPosition.
  ///
  /// In en, this message translates to:
  /// **'On hands and knees, hands under shoulders, knees under hips.'**
  String get exBirdDogPosition;

  /// No description provided for @exBirdDogStep1.
  ///
  /// In en, this message translates to:
  /// **'Keep your back flat.'**
  String get exBirdDogStep1;

  /// No description provided for @exBirdDogStep2.
  ///
  /// In en, this message translates to:
  /// **'Reach one arm forward and the opposite leg back.'**
  String get exBirdDogStep2;

  /// No description provided for @exBirdDogStep3.
  ///
  /// In en, this message translates to:
  /// **'Return slowly and switch sides.'**
  String get exBirdDogStep3;

  /// No description provided for @exBirdDogTip.
  ///
  /// In en, this message translates to:
  /// **'Move slowly; keep your hips level.'**
  String get exBirdDogTip;

  /// No description provided for @exBirdDogBenefit.
  ///
  /// In en, this message translates to:
  /// **'Improves balance and core control and supports the back.'**
  String get exBirdDogBenefit;

  /// No description provided for @exWallSitName.
  ///
  /// In en, this message translates to:
  /// **'Wall sit'**
  String get exWallSitName;

  /// No description provided for @exWallSitPosition.
  ///
  /// In en, this message translates to:
  /// **'Back flat against a wall, feet about 60 cm in front of it.'**
  String get exWallSitPosition;

  /// No description provided for @exWallSitStep1.
  ///
  /// In en, this message translates to:
  /// **'Slide down until your knees are bent at about 90°.'**
  String get exWallSitStep1;

  /// No description provided for @exWallSitStep2.
  ///
  /// In en, this message translates to:
  /// **'Hold with your weight in your heels.'**
  String get exWallSitStep2;

  /// No description provided for @exWallSitStep3.
  ///
  /// In en, this message translates to:
  /// **'Slide back up to stand.'**
  String get exWallSitStep3;

  /// No description provided for @exWallSitTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees over your ankles.'**
  String get exWallSitTip;

  /// No description provided for @exWallSitBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds thigh endurance without any equipment.'**
  String get exWallSitBenefit;

  /// No description provided for @exChairDipName.
  ///
  /// In en, this message translates to:
  /// **'Chair dip'**
  String get exChairDipName;

  /// No description provided for @exChairDipPosition.
  ///
  /// In en, this message translates to:
  /// **'Hands on the edge of a sturdy chair behind you, legs out in front.'**
  String get exChairDipPosition;

  /// No description provided for @exChairDipStep1.
  ///
  /// In en, this message translates to:
  /// **'Start with your arms straight.'**
  String get exChairDipStep1;

  /// No description provided for @exChairDipStep2.
  ///
  /// In en, this message translates to:
  /// **'Bend your elbows to lower your body.'**
  String get exChairDipStep2;

  /// No description provided for @exChairDipStep3.
  ///
  /// In en, this message translates to:
  /// **'Push back up until your arms are straight.'**
  String get exChairDipStep3;

  /// No description provided for @exChairDipTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back close to the chair and your shoulders down.'**
  String get exChairDipTip;

  /// No description provided for @exChairDipBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the backs of your arms.'**
  String get exChairDipBenefit;

  /// No description provided for @exStepUpName.
  ///
  /// In en, this message translates to:
  /// **'Step-up'**
  String get exStepUpName;

  /// No description provided for @exStepUpPosition.
  ///
  /// In en, this message translates to:
  /// **'Face a sturdy step or low bench.'**
  String get exStepUpPosition;

  /// No description provided for @exStepUpStep1.
  ///
  /// In en, this message translates to:
  /// **'Step up with one foot, pressing through the heel.'**
  String get exStepUpStep1;

  /// No description provided for @exStepUpStep2.
  ///
  /// In en, this message translates to:
  /// **'Bring the other foot up and stand tall.'**
  String get exStepUpStep2;

  /// No description provided for @exStepUpStep3.
  ///
  /// In en, this message translates to:
  /// **'Step down and switch the leading leg.'**
  String get exStepUpStep3;

  /// No description provided for @exStepUpTip.
  ///
  /// In en, this message translates to:
  /// **'Use a step that can\'t move; hold a wall for balance if needed.'**
  String get exStepUpTip;

  /// No description provided for @exStepUpBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens legs and helps with stairs and climbing.'**
  String get exStepUpBenefit;

  /// No description provided for @exCalfRaiseName.
  ///
  /// In en, this message translates to:
  /// **'Calf raise'**
  String get exCalfRaiseName;

  /// No description provided for @exCalfRaisePosition.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, feet hip-width apart, holding a wall for balance.'**
  String get exCalfRaisePosition;

  /// No description provided for @exCalfRaiseStep1.
  ///
  /// In en, this message translates to:
  /// **'Rise up onto the balls of your feet.'**
  String get exCalfRaiseStep1;

  /// No description provided for @exCalfRaiseStep2.
  ///
  /// In en, this message translates to:
  /// **'Pause at the top.'**
  String get exCalfRaiseStep2;

  /// No description provided for @exCalfRaiseStep3.
  ///
  /// In en, this message translates to:
  /// **'Lower your heels slowly.'**
  String get exCalfRaiseStep3;

  /// No description provided for @exCalfRaiseTip.
  ///
  /// In en, this message translates to:
  /// **'Move slowly; don\'t bounce.'**
  String get exCalfRaiseTip;

  /// No description provided for @exCalfRaiseBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the calves and ankles.'**
  String get exCalfRaiseBenefit;

  /// No description provided for @exDeadBugName.
  ///
  /// In en, this message translates to:
  /// **'Dead bug'**
  String get exDeadBugName;

  /// No description provided for @exDeadBugPosition.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, arms up, knees bent at 90° above your hips.'**
  String get exDeadBugPosition;

  /// No description provided for @exDeadBugStep1.
  ///
  /// In en, this message translates to:
  /// **'Press your lower back into the floor.'**
  String get exDeadBugStep1;

  /// No description provided for @exDeadBugStep2.
  ///
  /// In en, this message translates to:
  /// **'Lower one arm and the opposite leg towards the floor.'**
  String get exDeadBugStep2;

  /// No description provided for @exDeadBugStep3.
  ///
  /// In en, this message translates to:
  /// **'Return and switch sides.'**
  String get exDeadBugStep3;

  /// No description provided for @exDeadBugTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your lower back flat the whole time.'**
  String get exDeadBugTip;

  /// No description provided for @exDeadBugBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds core control with little strain on the back.'**
  String get exDeadBugBenefit;

  /// No description provided for @exGobletSquatName.
  ///
  /// In en, this message translates to:
  /// **'Goblet squat'**
  String get exGobletSquatName;

  /// No description provided for @exGobletSquatPosition.
  ///
  /// In en, this message translates to:
  /// **'Hold one dumbbell upright at your chest, feet shoulder-width apart.'**
  String get exGobletSquatPosition;

  /// No description provided for @exGobletSquatStep1.
  ///
  /// In en, this message translates to:
  /// **'Stand tall with your elbows pointing down.'**
  String get exGobletSquatStep1;

  /// No description provided for @exGobletSquatStep2.
  ///
  /// In en, this message translates to:
  /// **'Push your hips back and squat down.'**
  String get exGobletSquatStep2;

  /// No description provided for @exGobletSquatStep3.
  ///
  /// In en, this message translates to:
  /// **'Push through your heels to stand up.'**
  String get exGobletSquatStep3;

  /// No description provided for @exGobletSquatTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your chest up and the weight close to you.'**
  String get exGobletSquatTip;

  /// No description provided for @exGobletSquatBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds leg and glute strength with extra load.'**
  String get exGobletSquatBenefit;

  /// No description provided for @exDumbbellRowName.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell row'**
  String get exDumbbellRowName;

  /// No description provided for @exDumbbellRowPosition.
  ///
  /// In en, this message translates to:
  /// **'One hand and knee on a bench or chair, dumbbell in the other hand, back flat.'**
  String get exDumbbellRowPosition;

  /// No description provided for @exDumbbellRowStep1.
  ///
  /// In en, this message translates to:
  /// **'Let the arm hang straight down.'**
  String get exDumbbellRowStep1;

  /// No description provided for @exDumbbellRowStep2.
  ///
  /// In en, this message translates to:
  /// **'Pull the dumbbell up towards your hip.'**
  String get exDumbbellRowStep2;

  /// No description provided for @exDumbbellRowStep3.
  ///
  /// In en, this message translates to:
  /// **'Lower it slowly.'**
  String get exDumbbellRowStep3;

  /// No description provided for @exDumbbellRowTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back flat and don\'t twist.'**
  String get exDumbbellRowTip;

  /// No description provided for @exDumbbellRowBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the upper back and improves posture.'**
  String get exDumbbellRowBenefit;

  /// No description provided for @exShoulderPressName.
  ///
  /// In en, this message translates to:
  /// **'Shoulder press'**
  String get exShoulderPressName;

  /// No description provided for @exShoulderPressPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit or stand tall, dumbbells at shoulder height, palms forward.'**
  String get exShoulderPressPosition;

  /// No description provided for @exShoulderPressStep1.
  ///
  /// In en, this message translates to:
  /// **'Brace your stomach.'**
  String get exShoulderPressStep1;

  /// No description provided for @exShoulderPressStep2.
  ///
  /// In en, this message translates to:
  /// **'Press the dumbbells straight up overhead.'**
  String get exShoulderPressStep2;

  /// No description provided for @exShoulderPressStep3.
  ///
  /// In en, this message translates to:
  /// **'Lower them back to your shoulders.'**
  String get exShoulderPressStep3;

  /// No description provided for @exShoulderPressTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t arch your back; keep your ribs down.'**
  String get exShoulderPressTip;

  /// No description provided for @exShoulderPressBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds shoulder and arm strength for lifting overhead.'**
  String get exShoulderPressBenefit;

  /// No description provided for @exRomanianDeadliftName.
  ///
  /// In en, this message translates to:
  /// **'Romanian deadlift'**
  String get exRomanianDeadliftName;

  /// No description provided for @exRomanianDeadliftPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand with dumbbells in front of your thighs, knees slightly bent.'**
  String get exRomanianDeadliftPosition;

  /// No description provided for @exRomanianDeadliftStep1.
  ///
  /// In en, this message translates to:
  /// **'Keep your back flat and shoulders back.'**
  String get exRomanianDeadliftStep1;

  /// No description provided for @exRomanianDeadliftStep2.
  ///
  /// In en, this message translates to:
  /// **'Push your hips back and lower the weights along your legs.'**
  String get exRomanianDeadliftStep2;

  /// No description provided for @exRomanianDeadliftStep3.
  ///
  /// In en, this message translates to:
  /// **'Squeeze your glutes to stand up.'**
  String get exRomanianDeadliftStep3;

  /// No description provided for @exRomanianDeadliftTip.
  ///
  /// In en, this message translates to:
  /// **'Hinge at the hips; your back stays straight.'**
  String get exRomanianDeadliftTip;

  /// No description provided for @exRomanianDeadliftBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the back of the legs and the glutes.'**
  String get exRomanianDeadliftBenefit;

  /// No description provided for @exBicepCurlName.
  ///
  /// In en, this message translates to:
  /// **'Biceps curl'**
  String get exBicepCurlName;

  /// No description provided for @exBicepCurlPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, dumbbells at your sides, palms forward.'**
  String get exBicepCurlPosition;

  /// No description provided for @exBicepCurlStep1.
  ///
  /// In en, this message translates to:
  /// **'Keep your elbows close to your body.'**
  String get exBicepCurlStep1;

  /// No description provided for @exBicepCurlStep2.
  ///
  /// In en, this message translates to:
  /// **'Curl the weights up towards your shoulders.'**
  String get exBicepCurlStep2;

  /// No description provided for @exBicepCurlStep3.
  ///
  /// In en, this message translates to:
  /// **'Lower them slowly.'**
  String get exBicepCurlStep3;

  /// No description provided for @exBicepCurlTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t swing; only your forearms move.'**
  String get exBicepCurlTip;

  /// No description provided for @exBicepCurlBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the front of the arms.'**
  String get exBicepCurlBenefit;

  /// No description provided for @exBandRowName.
  ///
  /// In en, this message translates to:
  /// **'Band row'**
  String get exBandRowName;

  /// No description provided for @exBandRowPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit with legs straight, band around your feet, ends in your hands.'**
  String get exBandRowPosition;

  /// No description provided for @exBandRowStep1.
  ///
  /// In en, this message translates to:
  /// **'Sit tall with your arms straight.'**
  String get exBandRowStep1;

  /// No description provided for @exBandRowStep2.
  ///
  /// In en, this message translates to:
  /// **'Pull the ends towards your waist, squeezing your shoulder blades.'**
  String get exBandRowStep2;

  /// No description provided for @exBandRowStep3.
  ///
  /// In en, this message translates to:
  /// **'Return slowly.'**
  String get exBandRowStep3;

  /// No description provided for @exBandRowTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight; don\'t lean back.'**
  String get exBandRowTip;

  /// No description provided for @exBandRowBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the upper back with light, joint-friendly resistance.'**
  String get exBandRowBenefit;

  /// No description provided for @exBandPullApartName.
  ///
  /// In en, this message translates to:
  /// **'Band pull-apart'**
  String get exBandPullApartName;

  /// No description provided for @exBandPullApartPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, hold a band in front of you at shoulder height.'**
  String get exBandPullApartPosition;

  /// No description provided for @exBandPullApartStep1.
  ///
  /// In en, this message translates to:
  /// **'Keep your arms straight.'**
  String get exBandPullApartStep1;

  /// No description provided for @exBandPullApartStep2.
  ///
  /// In en, this message translates to:
  /// **'Pull the band apart until it touches your chest.'**
  String get exBandPullApartStep2;

  /// No description provided for @exBandPullApartStep3.
  ///
  /// In en, this message translates to:
  /// **'Return slowly.'**
  String get exBandPullApartStep3;

  /// No description provided for @exBandPullApartTip.
  ///
  /// In en, this message translates to:
  /// **'Squeeze your shoulder blades; keep your shoulders down.'**
  String get exBandPullApartTip;

  /// No description provided for @exBandPullApartBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the upper back and shoulders and helps posture.'**
  String get exBandPullApartBenefit;

  /// No description provided for @exLegPressName.
  ///
  /// In en, this message translates to:
  /// **'Leg press'**
  String get exLegPressName;

  /// No description provided for @exLegPressPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit in the machine, back flat on the pad, feet shoulder-width on the platform.'**
  String get exLegPressPosition;

  /// No description provided for @exLegPressStep1.
  ///
  /// In en, this message translates to:
  /// **'Release the safety and hold the handles.'**
  String get exLegPressStep1;

  /// No description provided for @exLegPressStep2.
  ///
  /// In en, this message translates to:
  /// **'Bend your knees to lower the platform towards you.'**
  String get exLegPressStep2;

  /// No description provided for @exLegPressStep3.
  ///
  /// In en, this message translates to:
  /// **'Press it away until your legs are almost straight.'**
  String get exLegPressStep3;

  /// No description provided for @exLegPressTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t lock your knees at the top.'**
  String get exLegPressTip;

  /// No description provided for @exLegPressBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds leg strength with back support.'**
  String get exLegPressBenefit;

  /// No description provided for @exLatPulldownName.
  ///
  /// In en, this message translates to:
  /// **'Lat pulldown'**
  String get exLatPulldownName;

  /// No description provided for @exLatPulldownPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit with thighs under the pad, hold the bar wider than your shoulders.'**
  String get exLatPulldownPosition;

  /// No description provided for @exLatPulldownStep1.
  ///
  /// In en, this message translates to:
  /// **'Sit tall and lean back slightly.'**
  String get exLatPulldownStep1;

  /// No description provided for @exLatPulldownStep2.
  ///
  /// In en, this message translates to:
  /// **'Pull the bar down to your upper chest.'**
  String get exLatPulldownStep2;

  /// No description provided for @exLatPulldownStep3.
  ///
  /// In en, this message translates to:
  /// **'Let it rise slowly until your arms are straight.'**
  String get exLatPulldownStep3;

  /// No description provided for @exLatPulldownTip.
  ///
  /// In en, this message translates to:
  /// **'Pull with your elbows; don\'t pull behind your neck.'**
  String get exLatPulldownTip;

  /// No description provided for @exLatPulldownBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the back and arms for pulling.'**
  String get exLatPulldownBenefit;

  /// No description provided for @exSeatedCableRowName.
  ///
  /// In en, this message translates to:
  /// **'Seated cable row'**
  String get exSeatedCableRowName;

  /// No description provided for @exSeatedCableRowPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit at the cable station, feet on the platform, knees soft, handle in both hands.'**
  String get exSeatedCableRowPosition;

  /// No description provided for @exSeatedCableRowStep1.
  ///
  /// In en, this message translates to:
  /// **'Sit tall with your arms straight.'**
  String get exSeatedCableRowStep1;

  /// No description provided for @exSeatedCableRowStep2.
  ///
  /// In en, this message translates to:
  /// **'Pull the handle to your stomach, squeezing your shoulder blades.'**
  String get exSeatedCableRowStep2;

  /// No description provided for @exSeatedCableRowStep3.
  ///
  /// In en, this message translates to:
  /// **'Return slowly.'**
  String get exSeatedCableRowStep3;

  /// No description provided for @exSeatedCableRowTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight; don\'t rock.'**
  String get exSeatedCableRowTip;

  /// No description provided for @exSeatedCableRowBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the middle back and improves posture.'**
  String get exSeatedCableRowBenefit;

  /// No description provided for @exChestPressName.
  ///
  /// In en, this message translates to:
  /// **'Chest press'**
  String get exChestPressName;

  /// No description provided for @exChestPressPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit with your back against the pad, handles at chest height.'**
  String get exChestPressPosition;

  /// No description provided for @exChestPressStep1.
  ///
  /// In en, this message translates to:
  /// **'Hold the handles with your elbows bent.'**
  String get exChestPressStep1;

  /// No description provided for @exChestPressStep2.
  ///
  /// In en, this message translates to:
  /// **'Push the handles forward until your arms are straight.'**
  String get exChestPressStep2;

  /// No description provided for @exChestPressStep3.
  ///
  /// In en, this message translates to:
  /// **'Return slowly.'**
  String get exChestPressStep3;

  /// No description provided for @exChestPressTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your shoulders back against the pad.'**
  String get exChestPressTip;

  /// No description provided for @exChestPressBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds chest and arm strength with a guided path.'**
  String get exChestPressBenefit;

  /// No description provided for @exDumbbellBenchPressName.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell bench press'**
  String get exDumbbellBenchPressName;

  /// No description provided for @exDumbbellBenchPressPosition.
  ///
  /// In en, this message translates to:
  /// **'Lie on a flat bench, dumbbells above your chest, feet on the floor.'**
  String get exDumbbellBenchPressPosition;

  /// No description provided for @exDumbbellBenchPressStep1.
  ///
  /// In en, this message translates to:
  /// **'Start with your arms straight above you.'**
  String get exDumbbellBenchPressStep1;

  /// No description provided for @exDumbbellBenchPressStep2.
  ///
  /// In en, this message translates to:
  /// **'Lower the dumbbells to the sides of your chest.'**
  String get exDumbbellBenchPressStep2;

  /// No description provided for @exDumbbellBenchPressStep3.
  ///
  /// In en, this message translates to:
  /// **'Press them back up.'**
  String get exDumbbellBenchPressStep3;

  /// No description provided for @exDumbbellBenchPressTip.
  ///
  /// In en, this message translates to:
  /// **'Control the weights; keep your wrists straight.'**
  String get exDumbbellBenchPressTip;

  /// No description provided for @exDumbbellBenchPressBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds chest, shoulder and arm strength.'**
  String get exDumbbellBenchPressBenefit;

  /// No description provided for @exLegCurlName.
  ///
  /// In en, this message translates to:
  /// **'Leg curl'**
  String get exLegCurlName;

  /// No description provided for @exLegCurlPosition.
  ///
  /// In en, this message translates to:
  /// **'Sit or lie in the machine with the pad just above your heels.'**
  String get exLegCurlPosition;

  /// No description provided for @exLegCurlStep1.
  ///
  /// In en, this message translates to:
  /// **'Hold the handles and keep your hips down.'**
  String get exLegCurlStep1;

  /// No description provided for @exLegCurlStep2.
  ///
  /// In en, this message translates to:
  /// **'Bend your knees to curl the pad towards you.'**
  String get exLegCurlStep2;

  /// No description provided for @exLegCurlStep3.
  ///
  /// In en, this message translates to:
  /// **'Return slowly.'**
  String get exLegCurlStep3;

  /// No description provided for @exLegCurlTip.
  ///
  /// In en, this message translates to:
  /// **'Move smoothly; don\'t lift your hips.'**
  String get exLegCurlTip;

  /// No description provided for @exLegCurlBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the hamstrings (back of the thighs).'**
  String get exLegCurlBenefit;

  /// No description provided for @exTricepsPushdownName.
  ///
  /// In en, this message translates to:
  /// **'Triceps pushdown'**
  String get exTricepsPushdownName;

  /// No description provided for @exTricepsPushdownPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand at a high cable with a bar or rope, elbows at your sides.'**
  String get exTricepsPushdownPosition;

  /// No description provided for @exTricepsPushdownStep1.
  ///
  /// In en, this message translates to:
  /// **'Start with your elbows bent.'**
  String get exTricepsPushdownStep1;

  /// No description provided for @exTricepsPushdownStep2.
  ///
  /// In en, this message translates to:
  /// **'Push down until your arms are straight.'**
  String get exTricepsPushdownStep2;

  /// No description provided for @exTricepsPushdownStep3.
  ///
  /// In en, this message translates to:
  /// **'Let the handle rise slowly.'**
  String get exTricepsPushdownStep3;

  /// No description provided for @exTricepsPushdownTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your elbows still at your sides.'**
  String get exTricepsPushdownTip;

  /// No description provided for @exTricepsPushdownBenefit.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the backs of the arms.'**
  String get exTricepsPushdownBenefit;

  /// No description provided for @exTreadmillInclineWalkName.
  ///
  /// In en, this message translates to:
  /// **'Incline treadmill walk'**
  String get exTreadmillInclineWalkName;

  /// No description provided for @exTreadmillInclineWalkPosition.
  ///
  /// In en, this message translates to:
  /// **'Stand on the treadmill, set a gentle incline and a brisk walking speed.'**
  String get exTreadmillInclineWalkPosition;

  /// No description provided for @exTreadmillInclineWalkStep1.
  ///
  /// In en, this message translates to:
  /// **'Walk tall, looking ahead.'**
  String get exTreadmillInclineWalkStep1;

  /// No description provided for @exTreadmillInclineWalkStep2.
  ///
  /// In en, this message translates to:
  /// **'Swing your arms naturally.'**
  String get exTreadmillInclineWalkStep2;

  /// No description provided for @exTreadmillInclineWalkStep3.
  ///
  /// In en, this message translates to:
  /// **'Keep a pace where you can talk but feel warm.'**
  String get exTreadmillInclineWalkStep3;

  /// No description provided for @exTreadmillInclineWalkTip.
  ///
  /// In en, this message translates to:
  /// **'Hold the rails only for balance, not to lean back.'**
  String get exTreadmillInclineWalkTip;

  /// No description provided for @exTreadmillInclineWalkBenefit.
  ///
  /// In en, this message translates to:
  /// **'Raises your heart rate with low impact on the joints.'**
  String get exTreadmillInclineWalkBenefit;

  /// No description provided for @exStationaryBikeName.
  ///
  /// In en, this message translates to:
  /// **'Stationary bike'**
  String get exStationaryBikeName;

  /// No description provided for @exStationaryBikePosition.
  ///
  /// In en, this message translates to:
  /// **'Adjust the seat so your knee is slightly bent at the bottom of the pedal stroke.'**
  String get exStationaryBikePosition;

  /// No description provided for @exStationaryBikeStep1.
  ///
  /// In en, this message translates to:
  /// **'Sit tall and hold the handlebars lightly.'**
  String get exStationaryBikeStep1;

  /// No description provided for @exStationaryBikeStep2.
  ///
  /// In en, this message translates to:
  /// **'Pedal at a steady, comfortable pace.'**
  String get exStationaryBikeStep2;

  /// No description provided for @exStationaryBikeStep3.
  ///
  /// In en, this message translates to:
  /// **'Add resistance if it feels too easy.'**
  String get exStationaryBikeStep3;

  /// No description provided for @exStationaryBikeTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees in line with your feet.'**
  String get exStationaryBikeTip;

  /// No description provided for @exStationaryBikeBenefit.
  ///
  /// In en, this message translates to:
  /// **'Builds heart fitness with low impact on the joints.'**
  String get exStationaryBikeBenefit;

  /// No description provided for @exRowingMachineName.
  ///
  /// In en, this message translates to:
  /// **'Rowing machine'**
  String get exRowingMachineName;

  /// No description provided for @exRowingMachinePosition.
  ///
  /// In en, this message translates to:
  /// **'Sit on the rower, feet strapped in, handle in both hands, arms straight.'**
  String get exRowingMachinePosition;

  /// No description provided for @exRowingMachineStep1.
  ///
  /// In en, this message translates to:
  /// **'Push with your legs first.'**
  String get exRowingMachineStep1;

  /// No description provided for @exRowingMachineStep2.
  ///
  /// In en, this message translates to:
  /// **'Lean back slightly and pull the handle to your lower ribs.'**
  String get exRowingMachineStep2;

  /// No description provided for @exRowingMachineStep3.
  ///
  /// In en, this message translates to:
  /// **'Return arms, then body, then legs, in that order.'**
  String get exRowingMachineStep3;

  /// No description provided for @exRowingMachineTip.
  ///
  /// In en, this message translates to:
  /// **'Power comes from your legs; keep your back straight.'**
  String get exRowingMachineTip;

  /// No description provided for @exRowingMachineBenefit.
  ///
  /// In en, this message translates to:
  /// **'A full-body cardio workout for legs, back and heart.'**
  String get exRowingMachineBenefit;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// No description provided for @muscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleQuads.
  ///
  /// In en, this message translates to:
  /// **'Thighs (front)'**
  String get muscleQuads;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Thighs (back)'**
  String get muscleHamstrings;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get muscleFullBody;

  /// No description provided for @muscleHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart and lungs'**
  String get muscleHeart;

  /// No description provided for @exMarchInPlaceName.
  ///
  /// In en, this message translates to:
  /// **'March in place'**
  String get exMarchInPlaceName;

  /// No description provided for @exMarchInPlacePosition.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, feet hip-width apart, arms relaxed.'**
  String get exMarchInPlacePosition;

  /// No description provided for @exMarchInPlaceStep1.
  ///
  /// In en, this message translates to:
  /// **'Lift one knee to a comfortable height.'**
  String get exMarchInPlaceStep1;

  /// No description provided for @exMarchInPlaceStep2.
  ///
  /// In en, this message translates to:
  /// **'Lower it and lift the other, swinging your arms.'**
  String get exMarchInPlaceStep2;

  /// No description provided for @exMarchInPlaceStep3.
  ///
  /// In en, this message translates to:
  /// **'Keep a brisk, steady rhythm for the set time.'**
  String get exMarchInPlaceStep3;

  /// No description provided for @exMarchInPlaceTip.
  ///
  /// In en, this message translates to:
  /// **'Land softly; lift your knees only as high as feels good.'**
  String get exMarchInPlaceTip;

  /// No description provided for @exMarchInPlaceBenefit.
  ///
  /// In en, this message translates to:
  /// **'Low-impact cardio that gets your heart going gently.'**
  String get exMarchInPlaceBenefit;

  /// No description provided for @planDay.
  ///
  /// In en, this message translates to:
  /// **'Day {letter}'**
  String planDay(String letter);

  /// No description provided for @planFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body {letter}'**
  String planFullBody(String letter);

  /// No description provided for @planUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper body {letter}'**
  String planUpperBody(String letter);

  /// No description provided for @planLowerBody.
  ///
  /// In en, this message translates to:
  /// **'Lower body {letter}'**
  String planLowerBody(String letter);

  /// No description provided for @planFocusFullBody.
  ///
  /// In en, this message translates to:
  /// **'Legs, push, pull, core and cardio'**
  String get planFocusFullBody;

  /// No description provided for @planFocusUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Chest, back, shoulders and arms'**
  String get planFocusUpperBody;

  /// No description provided for @planFocusLowerBody.
  ///
  /// In en, this message translates to:
  /// **'Legs, glutes and core'**
  String get planFocusLowerBody;

  /// No description provided for @rulesPlanSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} workouts a week, made on your phone from your profile.'**
  String rulesPlanSummary(int count);

  /// No description provided for @exerciseSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout setup'**
  String get exerciseSetupTitle;

  /// No description provided for @exerciseIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you work out?'**
  String get exerciseIntroTitle;

  /// No description provided for @exerciseIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Pick one and we\'ll make a weekly plan for your profile and goals. You can change it any time.'**
  String get exerciseIntroBody;

  /// No description provided for @envHome.
  ///
  /// In en, this message translates to:
  /// **'Home workout'**
  String get envHome;

  /// No description provided for @envHomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight exercises, no gym needed. Add dumbbells or bands if you have them.'**
  String get envHomeDesc;

  /// No description provided for @envGym.
  ///
  /// In en, this message translates to:
  /// **'Gym workout'**
  String get envGym;

  /// No description provided for @envGymDesc.
  ///
  /// In en, this message translates to:
  /// **'Machines, dumbbells and cardio equipment.'**
  String get envGymDesc;

  /// No description provided for @setupExtras.
  ///
  /// In en, this message translates to:
  /// **'Customise (optional)'**
  String get setupExtras;

  /// No description provided for @setupExtrasHint.
  ///
  /// In en, this message translates to:
  /// **'Leave these as they are if you\'re not sure.'**
  String get setupExtrasHint;

  /// No description provided for @setupLevel.
  ///
  /// In en, this message translates to:
  /// **'Fitness level'**
  String get setupLevel;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @setupMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes per workout'**
  String get setupMinutes;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @setupEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment at home'**
  String get setupEquipment;

  /// No description provided for @equipDumbbells.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get equipDumbbells;

  /// No description provided for @equipBands.
  ///
  /// In en, this message translates to:
  /// **'Resistance bands'**
  String get equipBands;

  /// No description provided for @setupLimitations.
  ///
  /// In en, this message translates to:
  /// **'Go easy on'**
  String get setupLimitations;

  /// No description provided for @setupLimitationsHint.
  ///
  /// In en, this message translates to:
  /// **'Exercises that load these areas are left out.'**
  String get setupLimitationsHint;

  /// No description provided for @limitKnees.
  ///
  /// In en, this message translates to:
  /// **'Knees'**
  String get limitKnees;

  /// No description provided for @limitLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get limitLowerBack;

  /// No description provided for @limitShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get limitShoulders;

  /// No description provided for @limitWrists.
  ///
  /// In en, this message translates to:
  /// **'Wrists'**
  String get limitWrists;

  /// No description provided for @setupSafety.
  ///
  /// In en, this message translates to:
  /// **'This is general fitness guidance, not medical advice. If you have a health condition or an injury, check with a doctor first, and stop any exercise that hurts.'**
  String get setupSafety;

  /// No description provided for @createPlan.
  ///
  /// In en, this message translates to:
  /// **'Create my plan'**
  String get createPlan;

  /// No description provided for @updatePlan.
  ///
  /// In en, this message translates to:
  /// **'Update my plan'**
  String get updatePlan;

  /// No description provided for @creatingPlan.
  ///
  /// In en, this message translates to:
  /// **'Creating your plan…'**
  String get creatingPlan;

  /// No description provided for @regeneratePlan.
  ///
  /// In en, this message translates to:
  /// **'Make a new plan'**
  String get regeneratePlan;

  /// No description provided for @regenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Make a new plan?'**
  String get regenerateTitle;

  /// No description provided for @regenerateBody.
  ///
  /// In en, this message translates to:
  /// **'Your current plan is replaced. Workouts you\'ve done stay in your history.'**
  String get regenerateBody;

  /// No description provided for @planMadeOffline.
  ///
  /// In en, this message translates to:
  /// **'Made without AI because it couldn\'t be reached. Try again for a plan written for you by AI.'**
  String get planMadeOffline;

  /// No description provided for @planTryAi.
  ///
  /// In en, this message translates to:
  /// **'Try AI again'**
  String get planTryAi;

  /// No description provided for @planOutdated.
  ///
  /// In en, this message translates to:
  /// **'Your profile or setup changed since this plan was made.'**
  String get planOutdated;

  /// No description provided for @planUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update plan'**
  String get planUpdate;

  /// No description provided for @todaysWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get todaysWorkout;

  /// No description provided for @progressDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String progressDone(int done, int total);

  /// No description provided for @statExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get statExercises;

  /// No description provided for @statDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statDone;

  /// No description provided for @statLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get statLeft;

  /// No description provided for @statTime.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get statTime;

  /// No description provided for @statKcal.
  ///
  /// In en, this message translates to:
  /// **'Est. kcal'**
  String get statKcal;

  /// No description provided for @aboutMinutes.
  ///
  /// In en, this message translates to:
  /// **'≈ {minutes} min'**
  String aboutMinutes(int minutes);

  /// No description provided for @aboutKcal.
  ///
  /// In en, this message translates to:
  /// **'≈ {kcal} kcal'**
  String aboutKcal(int kcal);

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set} other{{count} sets}}'**
  String setsCount(int count);

  /// No description provided for @repsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String repsCount(int count);

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String secondsShort(int seconds);

  /// No description provided for @setsTimesReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps}'**
  String setsTimesReps(int sets, String reps);

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get statusNotStarted;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusCompleted;

  /// No description provided for @kcalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Calories are rough estimates (often off by 30% or more). Fat loss depends on your overall eating and activity over weeks, not on single exercises.'**
  String get kcalDisclaimer;

  /// No description provided for @exerciseCardLabel.
  ///
  /// In en, this message translates to:
  /// **'{name}: {detail}, {status}'**
  String exerciseCardLabel(String name, String detail, String status);

  /// No description provided for @workoutSetupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Workout setup'**
  String get workoutSetupTooltip;

  /// No description provided for @startingPosition.
  ///
  /// In en, this message translates to:
  /// **'Starting position'**
  String get startingPosition;

  /// No description provided for @howToDoIt.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get howToDoIt;

  /// No description provided for @formTip.
  ///
  /// In en, this message translates to:
  /// **'Form tip'**
  String get formTip;

  /// No description provided for @musclesWorked.
  ///
  /// In en, this message translates to:
  /// **'Muscles worked'**
  String get musclesWorked;

  /// No description provided for @benefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefitsTitle;

  /// No description provided for @whyInPlan.
  ///
  /// In en, this message translates to:
  /// **'Why it\'s in your plan'**
  String get whyInPlan;

  /// No description provided for @statSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get statSets;

  /// No description provided for @statReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get statReps;

  /// No description provided for @statHold.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get statHold;

  /// No description provided for @statRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get statRest;

  /// No description provided for @kcalForExercise.
  ///
  /// In en, this message translates to:
  /// **'≈ {kcal} kcal for this exercise'**
  String kcalForExercise(int kcal);

  /// No description provided for @kcalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How calories are estimated'**
  String get kcalInfoTitle;

  /// No description provided for @kcalInfoMethod.
  ///
  /// In en, this message translates to:
  /// **'We use the exercise\'s effort level (MET {met}), your weight ({weight}) and the active time ({time}), and count only the calories above what you\'d burn resting. Rest between sets isn\'t counted. Age and gender aren\'t part of this method.'**
  String kcalInfoMethod(String met, String weight, String time);

  /// No description provided for @kcalInfoUncertainty.
  ///
  /// In en, this message translates to:
  /// **'Real calories vary with effort, pace and your body, often by 30% or more, so treat this as a rough guide.'**
  String get kcalInfoUncertainty;

  /// No description provided for @kcalInfoFat.
  ///
  /// In en, this message translates to:
  /// **'Fat loss comes from your overall eating and activity over weeks. No single exercise burns fat from one part of the body.'**
  String get kcalInfoFat;

  /// No description provided for @durationMinSec.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min {seconds} s'**
  String durationMinSec(int minutes, int seconds);

  /// No description provided for @demoLabel.
  ///
  /// In en, this message translates to:
  /// **'Demonstration of {name}'**
  String demoLabel(String name);

  /// No description provided for @demoPause.
  ///
  /// In en, this message translates to:
  /// **'Pause demonstration'**
  String get demoPause;

  /// No description provided for @demoPlay.
  ///
  /// In en, this message translates to:
  /// **'Play demonstration'**
  String get demoPlay;

  /// No description provided for @stepNumber.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String stepNumber(int number);

  /// No description provided for @exerciseNotFound.
  ///
  /// In en, this message translates to:
  /// **'This exercise isn\'t available.'**
  String get exerciseNotFound;

  /// No description provided for @kcalInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'How calories are estimated'**
  String get kcalInfoTooltip;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get startWorkout;

  /// No description provided for @continueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue ({done} of {total} sets done)'**
  String continueWorkout(int done, int total);

  /// No description provided for @doneToday.
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get doneToday;

  /// No description provided for @setOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Set {current} of {total}'**
  String setOfTotal(int current, int total);

  /// No description provided for @doneNextSet.
  ///
  /// In en, this message translates to:
  /// **'Done — next set'**
  String get doneNextSet;

  /// No description provided for @doneLastSet.
  ///
  /// In en, this message translates to:
  /// **'Done — finish'**
  String get doneLastSet;

  /// No description provided for @completeExercise.
  ///
  /// In en, this message translates to:
  /// **'Complete exercise'**
  String get completeExercise;

  /// No description provided for @endEarly.
  ///
  /// In en, this message translates to:
  /// **'End early'**
  String get endEarly;

  /// No description provided for @restLabel.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get restLabel;

  /// No description provided for @skipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip rest'**
  String get skipRest;

  /// No description provided for @addRestSeconds.
  ///
  /// In en, this message translates to:
  /// **'+{seconds} s'**
  String addRestSeconds(int seconds);

  /// No description provided for @nextSetUp.
  ///
  /// In en, this message translates to:
  /// **'Next: set {current} of {total}'**
  String nextSetUp(int current, int total);

  /// No description provided for @tapWhenDone.
  ///
  /// In en, this message translates to:
  /// **'Tap Done when you\'ve finished the set.'**
  String get tapWhenDone;

  /// No description provided for @timeUpHint.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up! Tap Done.'**
  String get timeUpHint;

  /// No description provided for @getReadyHint.
  ///
  /// In en, this message translates to:
  /// **'Get into the starting position, then tap Start.'**
  String get getReadyHint;

  /// No description provided for @exerciseCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise complete'**
  String get exerciseCompleteTitle;

  /// No description provided for @exerciseCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets · ≈ {kcal} kcal (estimate)'**
  String exerciseCompleteBody(int sets, int kcal);

  /// No description provided for @workoutCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout is complete!'**
  String get workoutCompleteTitle;

  /// No description provided for @nextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next exercise'**
  String get nextExercise;

  /// No description provided for @backToPlan.
  ///
  /// In en, this message translates to:
  /// **'Back to plan'**
  String get backToPlan;

  /// No description provided for @secondsLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds left'**
  String secondsLeftLabel(int seconds);

  /// No description provided for @setsDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} sets done'**
  String setsDoneLabel(int done, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
