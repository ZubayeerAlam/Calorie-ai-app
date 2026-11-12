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

  /// No description provided for @exercisePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your personalised workout plan will appear here.'**
  String get exercisePlaceholder;

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
