// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get pageNotFound => 'পেজটি পাওয়া যায়নি';

  @override
  String get nothingToAnalyze =>
      'বিশ্লেষণ করার কিছু নেই। অনুগ্রহ করে ফিরে যান।';

  @override
  String get save => 'সেভ করুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get edit => 'এডিট';

  @override
  String get add => 'যোগ করুন';

  @override
  String get back => 'ফিরে যান';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get required => 'প্রয়োজন';

  @override
  String get today => 'আজ';

  @override
  String kcalValue(String value) {
    return '$value ক্যালরি';
  }

  @override
  String gramsValue(String value) {
    return '$value গ্রা';
  }

  @override
  String kgValue(String value) {
    return '$value কেজি';
  }

  @override
  String lbValue(String value) {
    return '$value পাউন্ড';
  }

  @override
  String cmValue(String value) {
    return '$value সেমি';
  }

  @override
  String get unitKg => 'কেজি';

  @override
  String get unitLb => 'পাউন্ড';

  @override
  String get unitCm => 'সেমি';

  @override
  String get unitFt => 'ফুট';

  @override
  String get unitIn => 'ইঞ্চি';

  @override
  String get unitKcal => 'ক্যালরি';

  @override
  String get unitGrams => 'গ্রা';

  @override
  String eatenOfTarget(String eaten, String target) {
    return '$eaten / $target ক্যালরি';
  }

  @override
  String percent(String value) {
    return '$value%';
  }

  @override
  String todayDate(String date) {
    return 'আজ, $date';
  }

  @override
  String yesterdayDate(String date) {
    return 'গতকাল, $date';
  }

  @override
  String get authInvalidEmail => 'ইমেইল ঠিকানাটি সঠিক মনে হচ্ছে না।';

  @override
  String get authWrongCredentials => 'ইমেইল বা পাসওয়ার্ড ভুল।';

  @override
  String get authEmailInUse =>
      'এই ইমেইলে আগেই একটি অ্যাকাউন্ট আছে। সাইন ইন করুন।';

  @override
  String get authWeakPassword => 'কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড দিন।';

  @override
  String get authNetwork => 'ইন্টারনেট সংযোগ নেই। সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get authTooManyRequests =>
      'অনেকবার চেষ্টা করা হয়েছে। একটু অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get authNotEnabled => 'এই অ্যাপে ইমেইল দিয়ে সাইন ইন এখনও চালু হয়নি।';

  @override
  String get authUnknown => 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String signedInAs(String email) {
    return '$email হিসেবে সাইন ইন করা হয়েছে';
  }

  @override
  String get backupUnreachable =>
      'আপনার ব্যাকআপে পৌঁছানো যায়নি, তাই সাইন ইন হয়নি। সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get enterEmailFirst => 'আগে আপনার ইমেইল লিখুন।';

  @override
  String passwordResetSent(String email) {
    return '$email-এ পাসওয়ার্ড রিসেটের ইমেইল পাঠানো হয়েছে';
  }

  @override
  String get createAccount => 'অ্যাকাউন্ট খুলুন';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get signInIntro =>
      'আপনার খাবার, ওজন আর লক্ষ্যের ব্যাকআপ রাখুন এবং অন্য ফোনেও ব্যবহার করুন। এই ফোনে থাকা তথ্য রেখে আপনার অ্যাকাউন্টে যোগ করা হবে।';

  @override
  String get email => 'ইমেইল';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get passwordHelper => 'কমপক্ষে ৬ অক্ষর';

  @override
  String get hidePassword => 'পাসওয়ার্ড লুকান';

  @override
  String get showPassword => 'পাসওয়ার্ড দেখান';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get haveAccountSignIn => 'আগে থেকেই অ্যাকাউন্ট আছে? সাইন ইন করুন';

  @override
  String get newHereCreateAccount => 'নতুন? একটি অ্যাকাউন্ট খুলুন';

  @override
  String get logOutTitle => 'লগ আউট করবেন?';

  @override
  String get logOutBody =>
      'আপনার তথ্য অ্যাকাউন্টে থেকে যাবে, শুধু এই ফোন থেকে মুছে যাবে। আবার সাইন ইন করলে ফিরে পাবেন।';

  @override
  String get logOut => 'লগ আউট';

  @override
  String get backUpYourData => 'আপনার তথ্যের ব্যাকআপ রাখুন';

  @override
  String get signedIn => 'সাইন ইন করা আছে';

  @override
  String get backUpPitch =>
      'সাইন ইন করে আপনার খাবার ও ওজনের তথ্য নিরাপদ রাখুন এবং অন্য ফোনেও ব্যবহার করুন।';

  @override
  String get backedUpSynced => 'আপনার অ্যাকাউন্টে ব্যাকআপ ও সিঙ্ক করা আছে';

  @override
  String get signInOrCreate => 'সাইন ইন বা অ্যাকাউন্ট খুলুন';

  @override
  String healthAccessDenied(String app) {
    return 'অনুমতি দেওয়া হয়নি। $app-এর সেটিংসে গিয়ে অনুমতি দিতে পারেন।';
  }

  @override
  String healthInstall(String app) {
    return 'আপনার হাঁটা ও ব্যায়ামের তথ্য আনতে $app ইনস্টল বা আপডেট করুন।';
  }

  @override
  String get install => 'ইনস্টল';

  @override
  String get healthImporting =>
      'হাঁটার ধাপ ও ব্যায়ামের ক্যালরি নিজে থেকেই আনা হয়।';

  @override
  String get disconnect => 'সংযোগ বিচ্ছিন্ন করুন';

  @override
  String get healthPitch =>
      'আপনার সব ধাপ (অ্যাপ খোলার আগের হাঁটাও) এবং ব্যায়ামের ক্যালরি আনুন।';

  @override
  String get connecting => 'সংযোগ হচ্ছে…';

  @override
  String get connect => 'সংযোগ করুন';

  @override
  String healthConnected(String app) {
    return '$app সংযুক্ত';
  }

  @override
  String stepsCount(String steps) {
    return '$steps ধাপ';
  }

  @override
  String get allowStepAccess => 'ধাপ গোনার অনুমতি দিন';

  @override
  String get noStepSensor => 'ধাপ গোনার সেন্সর নেই';

  @override
  String dailyGoalKcal(String kcal) {
    return 'দৈনিক লক্ষ্য: $kcal ক্যালরি';
  }

  @override
  String goalKcalADay(String goal, String kcal) {
    return '$goal · দিনে $kcal ক্যালরি';
  }

  @override
  String get eaten => 'খাওয়া';

  @override
  String get burned => 'খরচ';

  @override
  String get walking => 'হাঁটা';

  @override
  String get activity => 'ব্যায়াম';

  @override
  String get logActivity => 'ব্যায়াম লগ করুন';

  @override
  String get kcalOver => 'ক্যালরি বেশি';

  @override
  String get kcalLeft => 'ক্যালরি বাকি';

  @override
  String get yourCaloriePlan => 'আপনার ক্যালরি পরিকল্পনা';

  @override
  String get caloriesAtRest => 'বিশ্রামে ক্যালরি (BMR)';

  @override
  String withActivity(String factor) {
    return 'কাজকর্ম সহ × $factor';
  }

  @override
  String get goalAdjustment => 'লক্ষ্য অনুযায়ী সমন্বয়';

  @override
  String get recommendedDailyTarget => 'প্রস্তাবিত দৈনিক লক্ষ্য';

  @override
  String raisedToMinimum(String kcal) {
    return 'সর্বনিম্ন $kcal ক্যালরিতে বাড়ানো হয়েছে';
  }

  @override
  String get yourCustomTarget => 'আপনার নিজের ঠিক করা লক্ষ্য';

  @override
  String get setOnAccount => 'অ্যাকাউন্ট থেকে সেট করা';

  @override
  String get macros => 'ম্যাক্রো';

  @override
  String get carbs => 'শর্করা';

  @override
  String get protein => 'প্রোটিন';

  @override
  String get fat => 'চর্বি';

  @override
  String macroShare(String percent, String kcal) {
    return '$percent · $kcal ক্যালরি/গ্রা';
  }

  @override
  String get previousDay => 'আগের দিন';

  @override
  String get nextDay => 'পরের দিন';

  @override
  String get chooseDate => 'তারিখ বেছে নিন';

  @override
  String get emptyToday =>
      'আজ এখনও কিছু লগ করা হয়নি। খাবার লগ করতে কোনো বেলার ＋ চাপুন।';

  @override
  String get emptyDay =>
      'এই দিনে কিছু লগ করা হয়নি। যোগ করতে কোনো বেলার ＋ চাপুন।';

  @override
  String get goodMorning => 'শুভ সকাল';

  @override
  String get goodAfternoon => 'শুভ দুপুর';

  @override
  String get goodEvening => 'শুভ সন্ধ্যা';

  @override
  String greetingName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String activitySheetSubtitle(String day) {
    return 'ব্যায়ামে খরচ হওয়া ক্যালরি · $day';
  }

  @override
  String plusHealthWorkouts(String kcal) {
    return 'এর সাথে হেলথ অ্যাপের ব্যায়াম থেকে $kcal ক্যালরি';
  }

  @override
  String get nothingLoggedYet => 'এখনও কিছু লগ করা হয়নি';

  @override
  String addToMeal(String meal) {
    return '$meal-এ যোগ করুন';
  }

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get keepWeightSteady => 'ওজন একই রাখুন';

  @override
  String kgPerWeek(String value) {
    return '$value কেজি / সপ্তাহ';
  }

  @override
  String get weight => 'ওজন';

  @override
  String get height => 'উচ্চতা';

  @override
  String get age => 'বয়স';

  @override
  String get bmi => 'BMI';

  @override
  String get breakfast => 'সকালের নাশতা';

  @override
  String get lunch => 'দুপুরের খাবার';

  @override
  String get dinner => 'রাতের খাবার';

  @override
  String get snacks => 'হালকা খাবার';

  @override
  String get enterNumber => 'একটি সংখ্যা লিখুন';

  @override
  String get addFoodTitle => 'খাবার যোগ করুন';

  @override
  String get scanPhoto => 'ছবি স্ক্যান করুন';

  @override
  String get changePhoto => 'ছবি বদলান';

  @override
  String get foodName => 'খাবারের নাম';

  @override
  String get caloriesKcal => 'ক্যালরি';

  @override
  String get enterWholeCalories => 'পূর্ণ সংখ্যায় ক্যালরি লিখুন';

  @override
  String get macrosBlankHint =>
      'প্রোটিন, শর্করা ও চর্বি ফাঁকা রাখলে ক্যালরি থেকে আনুমানিক হিসাব করা হবে।';

  @override
  String get proteinG => 'প্রোটিন (গ্রা)';

  @override
  String get carbsG => 'শর্করা (গ্রা)';

  @override
  String get fatG => 'চর্বি (গ্রা)';

  @override
  String get meal => 'বেলা';

  @override
  String get addManually => 'হাতে লিখে যোগ করুন';

  @override
  String get whatDidYouEat => 'আপনি কী খেয়েছেন?';

  @override
  String get manualIntro =>
      'আপনার খাবারের বর্ণনা দিন, AI ক্যালরি ও ম্যাক্রোর আনুমানিক হিসাব দেবে। একাধিক খাবার কমা দিয়ে লিখুন।';

  @override
  String get yourMeal => 'আপনার খাবার';

  @override
  String get yourMealHint => 'যেমন: ২টি ডিম ভাজি, মাখন দেওয়া টোস্ট, কালো কফি';

  @override
  String get moreDetails => 'আরও তথ্য (ঐচ্ছিক)';

  @override
  String get moreDetailsHint => 'এগুলো দিলে হিসাব আরও সঠিক হয়।';

  @override
  String get portionSize => 'পরিমাণ';

  @override
  String get portionSizeHint => 'যেমন: ১ বড় প্লেট, ২৫০ গ্রাম';

  @override
  String get cookingMethod => 'রান্নার ধরন';

  @override
  String get cookingMethodHint => 'যেমন: তেলে ভাজা, গ্রিল করা, সেদ্ধ';

  @override
  String get brandOrRestaurant => 'ব্র্যান্ড বা রেস্টুরেন্ট';

  @override
  String get brandHint => 'যেমন: স্টারবাকস, নেসলে';

  @override
  String get ingredients => 'উপকরণ';

  @override
  String get ingredientsHint => 'যেমন: অলিভ অয়েল, পনির, চিনি';

  @override
  String get enterNumbersMyself => 'নিজে সংখ্যা লিখব';

  @override
  String get analyzeWithAi => 'AI দিয়ে বিশ্লেষণ করুন';

  @override
  String get addFood => 'খাবার যোগ করুন';

  @override
  String get howToAddMeal => 'কীভাবে খাবার যোগ করতে চান?';

  @override
  String get scanWithCamera => 'ক্যামেরায় স্ক্যান করুন';

  @override
  String get scanWithCameraHint => 'খাবারের ছবি তুলুন বা বেছে নিন';

  @override
  String get addManuallyHint => 'খাবারের বর্ণনা দিয়ে পুষ্টির তথ্য পান';

  @override
  String get addFoodWithCamera => 'ক্যামেরা দিয়ে খাবার যোগ করুন';

  @override
  String get aiEstimateTag => '(AI-এর হিসাব)';

  @override
  String get estimatedTag => '(আনুমানিক)';

  @override
  String macroShort(String protein, String carbs, String fat) {
    return 'প্রো $proteinগ্রা শ $carbsগ্রা চ $fatগ্রা';
  }

  @override
  String deleteEntry(String name) {
    return '$name মুছুন';
  }

  @override
  String get detailPortion => 'পরিমাণ';

  @override
  String get detailCooking => 'রান্না';

  @override
  String get detailBrand => 'ব্র্যান্ড';

  @override
  String get detailIngredients => 'উপকরণ';

  @override
  String addedItemsToMeal(int count, String meal) {
    return '$meal-এ $countটি খাবার যোগ করা হয়েছে';
  }

  @override
  String get scanFood => 'খাবার স্ক্যান';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get useThisPhoto => 'এই ছবিটি ব্যবহার করুন';

  @override
  String get cameraPermissionRequired =>
      'খাবার স্ক্যান করতে ক্যামেরার অনুমতি দরকার।';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get imageLoadFailed => 'ছবিটি লোড করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get noFoodFound => 'কোনো খাবার পাওয়া যায়নি';

  @override
  String get noFoodFoundPhoto =>
      'এই ছবিতে কোনো খাবার খুঁজে পাওয়া যায়নি। অন্য ছবি দিন, বা নিজে খাবারটি লিখুন।';

  @override
  String get noFoodRecognised => 'কোনো খাবার চেনা যায়নি';

  @override
  String get noFoodRecognisedText =>
      'আপনার লেখায় কোনো খাবার পাওয়া যায়নি। অন্যভাবে লিখে দেখুন, বা নিজে সংখ্যাগুলো দিন।';

  @override
  String get cantReachAnalysis => 'বিশ্লেষণ সার্ভিসে পৌঁছানো যাচ্ছে না';

  @override
  String get checkConnection => 'সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get somethingWentWrong => 'কিছু একটা সমস্যা হয়েছে';

  @override
  String get analysisFailed =>
      'এবার বিশ্লেষণ কাজ করেনি। আবার চেষ্টা করুন, বা নিজে খাবারটি লিখুন।';

  @override
  String get tryAnotherPhoto => 'অন্য ছবি দিন';

  @override
  String get editDescription => 'বর্ণনা এডিট করুন';

  @override
  String get enterItManually => 'নিজে লিখুন';

  @override
  String get analyzingMeal => 'আপনার খাবার বিশ্লেষণ করা হচ্ছে…';

  @override
  String get takesFewSeconds => 'সাধারণত কয়েক সেকেন্ড লাগে।';

  @override
  String get allItemsRemoved => 'সব খাবার সরানো হয়েছে';

  @override
  String weFoundItems(int count) {
    return '$countটি খাবার পাওয়া গেছে';
  }

  @override
  String get goBackAnotherPhoto => 'অন্য ছবি দিতে ফিরে যান।';

  @override
  String get goBackEditDescription => 'বর্ণনা এডিট করতে ফিরে যান।';

  @override
  String get aiEstimateCheck => 'AI-এর হিসাব · সেভ করার আগে দেখে এডিট করুন';

  @override
  String get addTo => 'যোগ করুন';

  @override
  String addToMealKcal(String meal, String kcal) {
    return '$meal-এ যোগ করুন · $kcal ক্যালরি';
  }

  @override
  String get addAName => 'একটি নাম দিন';

  @override
  String removeItem(String name) {
    return '$name সরান';
  }

  @override
  String get portion => 'পরিমাণ';

  @override
  String get calories => 'ক্যালরি';

  @override
  String get demoPhoto =>
      'ডেমো ফল: AI বিশ্লেষণ এখনও যুক্ত হয়নি, তাই এগুলো নমুনা খাবার, আপনার ছবির খাবার নয়। সেভ করার আগে এডিট করুন।';

  @override
  String get demoText =>
      'ডেমো ফল: AI বিশ্লেষণ এখনও যুক্ত হয়নি, তাই এগুলো নমুনা সংখ্যা, আপনার লেখা খাবারের আসল পুষ্টি নয়। সেভ করার আগে এডিট করুন।';

  @override
  String get youDescribed => 'আপনার বর্ণনা';

  @override
  String detailLine(String label) {
    return '$label: ';
  }

  @override
  String get tabHome => 'হোম';

  @override
  String get tabTracker => 'ট্র্যাকার';

  @override
  String get tabExercise => 'ব্যায়াম';

  @override
  String get exercisePlaceholder =>
      'আপনার নিজের জন্য তৈরি ব্যায়ামের পরিকল্পনা এখানে দেখা যাবে।';

  @override
  String get tabAccount => 'অ্যাকাউন্ট';

  @override
  String get howActive => 'আপনি কতটা সক্রিয়?';

  @override
  String get whenBorn => 'আপনার জন্ম কবে?';

  @override
  String ageRange(String min, String max) {
    return 'আপনার বয়স $min থেকে $max বছরের মধ্যে হতে হবে।';
  }

  @override
  String get specificDiet => 'আপনি কি নির্দিষ্ট কোনো ডায়েট মেনে চলেন?';

  @override
  String get whenDinner => 'সাধারণত কখন রাতের\nখাবার খান?';

  @override
  String get chooseGender => 'আপনার লিঙ্গ বেছে নিন';

  @override
  String get mainGoal => 'আপনার প্রধান লক্ষ্য কী?';

  @override
  String get howTall => 'আপনার উচ্চতা কত?';

  @override
  String get ftIn => 'ফুট / ইঞ্চি';

  @override
  String get whatsYourName => 'আপনার নাম কী?';

  @override
  String get yourName => 'আপনার নাম';

  @override
  String personalizing(String app) {
    return 'আপনার $app\nঅভিজ্ঞতা সাজানো হচ্ছে...';
  }

  @override
  String get hangTight =>
      'একটু অপেক্ষা করুন! শুধু আপনার জন্য একটি পরিকল্পনা তৈরি হচ্ছে।';

  @override
  String get planReady => 'আপনার পরিকল্পনা তৈরি';

  @override
  String get caloriesPerDay => 'ক্যালরি প্রতিদিন';

  @override
  String kgPerWeekSigned(String value) {
    return 'প্রতি সপ্তাহে $value কেজি';
  }

  @override
  String get whatsYourWeight => 'আপনার ওজন কত?';

  @override
  String get finish => 'শেষ করুন';

  @override
  String get continueButton => 'এগিয়ে যান';

  @override
  String stepOf(String step, String total) {
    return '$step / $total';
  }

  @override
  String get genderMale => 'পুরুষ';

  @override
  String get genderFemale => 'নারী';

  @override
  String get genderOther => 'অন্যান্য';

  @override
  String get goalLose => 'ওজন কমানো';

  @override
  String get goalMaintain => 'ওজন ধরে রাখা';

  @override
  String get goalGain => 'ওজন বাড়ানো';

  @override
  String get focusGainMuscle => 'পেশি বাড়ানো';

  @override
  String get focusBoostEnergy => 'শক্তি বাড়ানো';

  @override
  String get focusImproveNutrition => 'পুষ্টি উন্নত করা';

  @override
  String get activitySedentary => 'অলস';

  @override
  String get activityLight => 'হালকা সক্রিয়';

  @override
  String get activityModerate => 'মাঝারি সক্রিয়';

  @override
  String get activityActive => 'খুব সক্রিয়';

  @override
  String get activitySedentaryDesc => 'অল্প বা কোনো ব্যায়াম নেই, বসে কাজ';

  @override
  String get activityLightDesc => 'সপ্তাহে ১–৩ দিন হালকা ব্যায়াম';

  @override
  String get activityModerateDesc => 'সপ্তাহে ৩–৫ দিন মাঝারি ব্যায়াম';

  @override
  String get activityActiveDesc => 'সপ্তাহে ৬–৭ দিন কঠোর ব্যায়াম';

  @override
  String get dietClassic => 'সাধারণ';

  @override
  String get dietVegetarian => 'নিরামিষ';

  @override
  String get dietVegan => 'ভিগান';

  @override
  String get dietPescatarian => 'পেসকাটেরিয়ান';

  @override
  String get dietKeto => 'কিটো';

  @override
  String get dietClassicDesc => 'কোনো বাধা নেই';

  @override
  String get dietVegetarianDesc => 'মাংস বা মাছ নয়';

  @override
  String get dietVeganDesc => 'কোনো প্রাণিজ খাবার নয়';

  @override
  String get dietPescatarianDesc => 'মাছ খান, মাংস নয়';

  @override
  String get dietKetoDesc => 'বেশি চর্বি, খুব কম শর্করা';

  @override
  String get bmiUnderweight => 'কম ওজন';

  @override
  String get bmiHealthy => 'স্বাস্থ্যকর';

  @override
  String get bmiOverweight => 'বেশি ওজন';

  @override
  String get bmiObese => 'স্থূল';

  @override
  String get birthday => 'জন্মদিন';

  @override
  String get usualDinnerTime => 'রাতের খাবারের সাধারণ সময়';

  @override
  String get profileSaved => 'প্রোফাইল সেভ হয়েছে';

  @override
  String get editProfile => 'প্রোফাইল এডিট';

  @override
  String get name => 'নাম';

  @override
  String get units => 'একক';

  @override
  String get unitsMetric => 'কেজি · সেমি';

  @override
  String get unitsImperial => 'পাউন্ড · ফুট';

  @override
  String get logWeightOnTracker => 'ট্র্যাকার ট্যাবে নতুন ওজন লগ করুন।';

  @override
  String ageValue(String age) {
    return 'বয়স $age';
  }

  @override
  String get gender => 'লিঙ্গ';

  @override
  String get weightGoal => 'ওজনের লক্ষ্য';

  @override
  String get weightGoalHint => 'এটি দিয়ে আপনার ক্যালরির লক্ষ্য ঠিক হয়।';

  @override
  String get alsoFocusOn => 'আরও যেদিকে নজর দেবেন';

  @override
  String get activityLevel => 'কাজকর্মের মাত্রা';

  @override
  String get diet => 'ডায়েট';

  @override
  String get heightRangeError =>
      '১০০ থেকে ২৫০ সেমির (৩′৪″–৮′২″) মধ্যে উচ্চতা লিখুন';

  @override
  String get profileAndGoals => 'প্রোফাইল ও লক্ষ্য';

  @override
  String dailyCalorieGoal(String kcal) {
    return 'দৈনিক ক্যালরির লক্ষ্য: $kcal ক্যালরি';
  }

  @override
  String customRecommended(String kcal) {
    return 'নিজের ঠিক করা · প্রস্তাবিত $kcal ক্যালরি';
  }

  @override
  String get recommendedForProfile => 'আপনার প্রোফাইলের জন্য প্রস্তাবিত';

  @override
  String get resetToRecommended => 'প্রস্তাবিত মানে ফিরিয়ে নিন';

  @override
  String get appearance => 'চেহারা';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get language => 'ভাষা';

  @override
  String get languageSystem => 'সিস্টেম';

  @override
  String profileSummary(
    String age,
    String height,
    String weight,
    String goal,
    String activity,
  ) {
    return '$age বছর · $height · $weight\n$goal · $activity';
  }

  @override
  String get resetAllDataTitle => 'সব তথ্য মুছে ফেলবেন?';

  @override
  String get resetSignedIn =>
      'এটি এই ফোন ও আপনার অ্যাকাউন্ট থেকে প্রোফাইল, খাবার, ওজন ও ব্যায়ামের তথ্য মুছে আবার শুরু থেকে সেটআপ করাবে। আপনি সাইন ইন থাকবেন। এটি আর ফেরানো যাবে না।';

  @override
  String get resetLocal =>
      'এটি এই ফোন থেকে প্রোফাইল, খাবার, ওজন ও ব্যায়ামের তথ্য মুছে আবার শুরু থেকে সেটআপ করাবে। এটি আর ফেরানো যাবে না।';

  @override
  String get deleteEverything => 'সব মুছে ফেলুন';

  @override
  String get resetAllData => 'সব তথ্য মুছুন';

  @override
  String get notificationsOff =>
      'Cal AI-এর নোটিফিকেশন বন্ধ আছে। রিমাইন্ডার পেতে ফোনের সেটিংসে অনুমতি দিন।';

  @override
  String get reminders => 'রিমাইন্ডার';

  @override
  String get remindersIntro =>
      'রিমাইন্ডার চালু করলে Cal AI আপনাকে খাবার লগ করার কথা মনে করিয়ে দেবে। কোনো বেলার খাবার লগ করা হয়ে গেলে সেই রিমাইন্ডার আর আসবে না।';

  @override
  String get mealReminders => 'খাবারের রিমাইন্ডার';

  @override
  String get mealRemindersChannelDesc =>
      'সকালের নাশতা, দুপুর ও রাতের খাবার লগ করার রিমাইন্ডার';

  @override
  String get dinnerTimeFromProfile => 'আপনার প্রোফাইলের রাতের খাবারের সময়';

  @override
  String mealReminder(String meal) {
    return '$meal-এর রিমাইন্ডার';
  }

  @override
  String get logged => 'লগ করা হয়েছে';

  @override
  String reminderAt(String time) {
    return '$time-এ রিমাইন্ডার';
  }

  @override
  String notLoggedYet(String time) {
    return 'এখনও লগ করা হয়নি · $time';
  }

  @override
  String get logNow => 'এখন লগ করুন';

  @override
  String get reminderBody => 'আজকের লক্ষ্যে থাকতে যা খাচ্ছেন লগ করুন।';

  @override
  String get reminderBreakfast => 'সকালের নাশতার সময়';

  @override
  String get reminderLunch => 'দুপুরের খাবারের সময়';

  @override
  String get reminderDinner => 'রাতের খাবারের সময়';

  @override
  String get reminderSnack => 'হালকা খাবারের সময়';

  @override
  String get periodWeek => 'সপ্তাহ';

  @override
  String get periodMonth => 'মাস';

  @override
  String get tracker => 'ট্র্যাকার';

  @override
  String targetDashedLine(String kcal) {
    return 'লক্ষ্য $kcal ক্যালরি · ড্যাশ দেওয়া রেখা';
  }

  @override
  String get onTarget => 'লক্ষ্যে';

  @override
  String get under => 'কম';

  @override
  String get over => 'বেশি';

  @override
  String get history => 'ইতিহাস';

  @override
  String get nothingInPeriod => 'এই সময়ে এখনও কিছু লগ করা হয়নি';

  @override
  String get tapDayToOpen => 'হোমে দেখতে কোনো দিনে চাপুন';

  @override
  String historyMacros(String protein, String carbs, String fat) {
    return 'প্রো $protein গ্রা · শ $carbs গ্রা · চ $fat গ্রা';
  }

  @override
  String get logWeight => 'ওজন লগ করুন';

  @override
  String get logWeightSubtitle =>
      'আজকের ওজন। আপনার ক্যালরির লক্ষ্য এটি অনুযায়ী বদলাবে।';

  @override
  String get realisticWeight => 'বাস্তবসম্মত ওজন লিখুন';

  @override
  String get dailyAverageLogged => 'লগ করা দিনগুলোর দৈনিক গড়';

  @override
  String gramsOfTarget(String value, String target) {
    return '$value / $target গ্রা';
  }

  @override
  String get steps => 'ধাপ';

  @override
  String get noStepsYet => 'এখনও কোনো ধাপ গোনা হয়নি';

  @override
  String stepsAverage(String avg, String total) {
    return 'দিনে গড়ে $avg · মোট $total';
  }

  @override
  String get dayStreak => 'দিন টানা';

  @override
  String get avgKcalDay => 'গড় ক্যালরি / দিন';

  @override
  String get daysOnTarget => 'দিন লক্ষ্যে';

  @override
  String get logWeightTrend => 'ট্রেন্ড দেখতে ওজন লগ করুন';

  @override
  String changeInPeriod(String change) {
    return 'এই সময়ে $change';
  }

  @override
  String get log => 'লগ';
}
