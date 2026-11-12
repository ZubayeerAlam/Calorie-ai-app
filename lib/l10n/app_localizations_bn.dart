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

  @override
  String get exPushUpName => 'পুশ-আপ';

  @override
  String get exPushUpPosition =>
      'হাত কাঁধের ঠিক নিচে, মাথা থেকে গোড়ালি পর্যন্ত শরীর সোজা।';

  @override
  String get exPushUpStep1 => 'হাত সোজা রেখে ওপরের অবস্থান থেকে শুরু করুন।';

  @override
  String get exPushUpStep2 => 'কনুই ভাঁজ করে বুক মেঝের একটু ওপরে নামান।';

  @override
  String get exPushUpStep3 => 'মেঝে ঠেলে আবার হাত সোজা করুন।';

  @override
  String get exPushUpTip => 'কোমর সমান রাখুন; ঝুলতে বা উঁচু হতে দেবেন না।';

  @override
  String get exPushUpBenefit => 'শরীরের ওপরের অংশের শক্তি ও সহনশক্তি বাড়ায়।';

  @override
  String get exKneePushUpName => 'হাঁটু-ভর পুশ-আপ';

  @override
  String get exKneePushUpPosition =>
      'হাঁটু মেঝেতে, হাত কাঁধের নিচে, মাথা থেকে হাঁটু পর্যন্ত শরীর সোজা।';

  @override
  String get exKneePushUpStep1 => 'হাত সোজা রেখে শুরু করুন।';

  @override
  String get exKneePushUpStep2 => 'বুক মেঝের দিকে নামান।';

  @override
  String get exKneePushUpStep3 => 'হাত সোজা না হওয়া পর্যন্ত ওপরে ঠেলুন।';

  @override
  String get exKneePushUpTip => 'পেট শক্ত রাখুন যাতে পিঠ সমান থাকে।';

  @override
  String get exKneePushUpBenefit =>
      'সহজ ধরনের পুশ-আপ, বুক ও হাতের শক্তি বাড়ায়।';

  @override
  String get exInclinePushUpName => 'ইনক্লাইন পুশ-আপ';

  @override
  String get exInclinePushUpPosition =>
      'মজবুত টেবিল বা চেয়ারের কিনারায় হাত, পা পেছনে, শরীর সোজা।';

  @override
  String get exInclinePushUpStep1 => 'হাত সোজা রেখে শুরু করুন।';

  @override
  String get exInclinePushUpStep2 => 'কনুই ভাঁজ করে বুক কিনারার কাছে আনুন।';

  @override
  String get exInclinePushUpStep3 => 'হাত সোজা না হওয়া পর্যন্ত পেছনে ঠেলুন।';

  @override
  String get exInclinePushUpTip =>
      'চেয়ার বা টেবিল যেন পিছলে না যায়, দেখে নিন।';

  @override
  String get exInclinePushUpBenefit =>
      'পূর্ণ পুশ-আপের প্রস্তুতির জন্য সহজ ধরন।';

  @override
  String get exSquatName => 'স্কোয়াট';

  @override
  String get exSquatPosition =>
      'পা কাঁধের সমান ফাঁকে, আঙুল একটু বাইরে, বুক উঁচু।';

  @override
  String get exSquatStep1 => 'গোড়ালিতে ভর দিয়ে সোজা দাঁড়ান।';

  @override
  String get exSquatStep2 =>
      'চেয়ারে বসার মতো কোমর পেছনে নিয়ে হাঁটু ভাঁজ করুন।';

  @override
  String get exSquatStep3 => 'গোড়ালিতে চাপ দিয়ে আবার দাঁড়ান।';

  @override
  String get exSquatTip => 'হাঁটু পায়ের আঙুলের সোজাসুজি রাখুন।';

  @override
  String get exSquatBenefit => 'দৈনন্দিন চলাফেরার জন্য পা ও নিতম্ব শক্ত করে।';

  @override
  String get exLungeName => 'লাঞ্জ';

  @override
  String get exLungePosition =>
      'সোজা দাঁড়ান, পা কোমরের সমান ফাঁকে, হাত কোমরে।';

  @override
  String get exLungeStep1 => 'সামনে একটি বড় পা ফেলুন।';

  @override
  String get exLungeStep2 =>
      'দুই হাঁটু প্রায় ৯০° ভাঁজ না হওয়া পর্যন্ত নামুন।';

  @override
  String get exLungeStep3 => 'সামনের পায়ে চাপ দিয়ে ফিরে আসুন; পা বদলান।';

  @override
  String get exLungeTip =>
      'সামনের হাঁটু গোড়ালির ওপরে রাখুন, আঙুল ছাড়িয়ে নয়।';

  @override
  String get exLungeBenefit => 'এক পা করে পায়ের শক্তি ও ভারসাম্য বাড়ায়।';

  @override
  String get exGluteBridgeName => 'গ্লুট ব্রিজ';

  @override
  String get exGluteBridgePosition =>
      'চিত হয়ে শুয়ে হাঁটু ভাঁজ, পা মেঝেতে সমান, কোমরের সমান ফাঁকে।';

  @override
  String get exGluteBridgeStep1 => 'হাত শরীরের দুপাশে রাখুন।';

  @override
  String get exGluteBridgeStep2 =>
      'নিতম্ব শক্ত করে কোমর তুলুন, হাঁটু থেকে কাঁধ পর্যন্ত সোজা হওয়া পর্যন্ত।';

  @override
  String get exGluteBridgeStep3 => 'ধীরে ধীরে কোমর নামান।';

  @override
  String get exGluteBridgeTip =>
      'গোড়ালিতে চাপ দিন, কোমরের নিচের অংশ বাঁকাবেন না।';

  @override
  String get exGluteBridgeBenefit =>
      'নিতম্ব ও পায়ের পেছন শক্ত করে; হাঁটুর ওপর চাপ কম।';

  @override
  String get exPlankName => 'প্ল্যাঙ্ক';

  @override
  String get exPlankPosition =>
      'কাঁধের নিচে কনুই থেকে হাত মেঝেতে, পা পেছনে সোজা।';

  @override
  String get exPlankStep1 =>
      'মাথা থেকে গোড়ালি পর্যন্ত সোজা রেখায় শরীর তুলুন।';

  @override
  String get exPlankStep2 => 'পেট ও নিতম্ব শক্ত করুন।';

  @override
  String get exPlankStep3 => 'অবস্থান ধরে রাখুন, শ্বাস নিতে থাকুন।';

  @override
  String get exPlankTip => 'কোমর নামতে বা উঠতে দেবেন না।';

  @override
  String get exPlankBenefit => 'পেটের পেশি শক্ত করে, যা পিঠকে সহায়তা করে।';

  @override
  String get exSidePlankName => 'সাইড প্ল্যাঙ্ক';

  @override
  String get exSidePlankPosition =>
      'একপাশে শুয়ে কাঁধের নিচে কনুই, পা একটার ওপর আরেকটা।';

  @override
  String get exSidePlankStep1 => 'শরীর সোজা হওয়া পর্যন্ত কোমর তুলুন।';

  @override
  String get exSidePlankStep2 => 'কোমর উঁচু রেখে ধরে রাখুন।';

  @override
  String get exSidePlankStep3 => 'ধীরে নামুন; পাশ বদলান।';

  @override
  String get exSidePlankTip => 'কনুই ঠিক কাঁধের নিচে রাখুন।';

  @override
  String get exSidePlankBenefit =>
      'পেটের দুপাশের পেশি শক্ত করে ও স্থিরতা বাড়ায়।';

  @override
  String get exMountainClimberName => 'মাউন্টেন ক্লাইম্বার';

  @override
  String get exMountainClimberPosition =>
      'হাই প্ল্যাঙ্ক: হাত কাঁধের নিচে, শরীর সোজা।';

  @override
  String get exMountainClimberStep1 => 'এক হাঁটু বুকের দিকে আনুন।';

  @override
  String get exMountainClimberStep2 => 'জায়গায় দৌড়ানোর মতো দ্রুত পা বদলান।';

  @override
  String get exMountainClimberStep3 =>
      'নির্ধারিত সময় ধরে একই গতিতে চালিয়ে যান।';

  @override
  String get exMountainClimberTip => 'কোমর নিচু রাখুন, কাঁধ হাতের ওপরে।';

  @override
  String get exMountainClimberBenefit =>
      'পেটের পেশি কাজ করার সাথে হৃৎস্পন্দন বাড়ায়।';

  @override
  String get exJumpingJackName => 'জাম্পিং জ্যাক';

  @override
  String get exJumpingJackPosition =>
      'পা একসাথে, হাত শরীরের দুপাশে রেখে দাঁড়ান।';

  @override
  String get exJumpingJackStep1 =>
      'লাফ দিয়ে পা ফাঁক করুন আর হাত মাথার ওপরে তুলুন।';

  @override
  String get exJumpingJackStep2 => 'লাফ দিয়ে শুরুর অবস্থানে ফিরুন।';

  @override
  String get exJumpingJackStep3 => 'নির্ধারিত সময় ধরে একই ছন্দে করুন।';

  @override
  String get exJumpingJackTip => 'পায়ের সামনের অংশে আলতো করে নামুন।';

  @override
  String get exJumpingJackBenefit => 'পুরো শরীর গরম করার সহজ কার্ডিও ব্যায়াম।';

  @override
  String get exHighKneesName => 'হাই নিজ';

  @override
  String get exHighKneesPosition => 'সোজা দাঁড়ান, পা কোমরের সমান ফাঁকে।';

  @override
  String get exHighKneesStep1 =>
      'জায়গায় দৌড়ান, এক হাঁটু কোমরের উচ্চতায় তুলুন।';

  @override
  String get exHighKneesStep2 => 'হাত দুলিয়ে দ্রুত পা বদলান।';

  @override
  String get exHighKneesStep3 => 'নির্ধারিত সময় ধরে চালিয়ে যান।';

  @override
  String get exHighKneesTip => 'পায়ের সামনের অংশে থাকুন, সোজা থাকুন।';

  @override
  String get exHighKneesBenefit =>
      'হৃৎস্পন্দন বাড়ায় ও পায়ের পেশি কাজ করায়।';

  @override
  String get exSupermanName => 'সুপারম্যান';

  @override
  String get exSupermanPosition => 'উপুড় হয়ে শুয়ে হাত সামনে লম্বা, পা সোজা।';

  @override
  String get exSupermanStep1 => 'ঘাড় আরামে রাখতে মেঝের দিকে তাকান।';

  @override
  String get exSupermanStep2 => 'হাত, বুক ও পা মেঝে থেকে একটু তুলুন।';

  @override
  String get exSupermanStep3 => 'একটু ধরে রেখে ধীরে নামান।';

  @override
  String get exSupermanTip =>
      'কয়েক সেন্টিমিটার তুলুন; মাথা পেছনে ঝাঁকাবেন না।';

  @override
  String get exSupermanBenefit => 'পিঠের পেশি শক্ত করে।';

  @override
  String get exBirdDogName => 'বার্ড ডগ';

  @override
  String get exBirdDogPosition =>
      'হাত ও হাঁটুর ভরে, হাত কাঁধের নিচে, হাঁটু কোমরের নিচে।';

  @override
  String get exBirdDogStep1 => 'পিঠ সমান রাখুন।';

  @override
  String get exBirdDogStep2 => 'এক হাত সামনে আর বিপরীত পা পেছনে বাড়ান।';

  @override
  String get exBirdDogStep3 => 'ধীরে ফিরে এসে পাশ বদলান।';

  @override
  String get exBirdDogTip => 'ধীরে নড়ুন; কোমর সমান রাখুন।';

  @override
  String get exBirdDogBenefit =>
      'ভারসাম্য ও পেটের নিয়ন্ত্রণ বাড়ায়, পিঠকে সহায়তা করে।';

  @override
  String get exWallSitName => 'ওয়াল সিট';

  @override
  String get exWallSitPosition =>
      'দেয়ালে পিঠ সোজা ঠেকিয়ে, পা দেয়াল থেকে প্রায় ৬০ সেমি সামনে।';

  @override
  String get exWallSitStep1 =>
      'হাঁটু প্রায় ৯০° ভাঁজ না হওয়া পর্যন্ত নিচে নামুন।';

  @override
  String get exWallSitStep2 => 'গোড়ালিতে ভর রেখে ধরে রাখুন।';

  @override
  String get exWallSitStep3 => 'আবার ওপরে উঠে দাঁড়ান।';

  @override
  String get exWallSitTip => 'হাঁটু গোড়ালির ওপরে রাখুন।';

  @override
  String get exWallSitBenefit => 'কোনো সরঞ্জাম ছাড়াই উরুর সহনশক্তি বাড়ায়।';

  @override
  String get exChairDipName => 'চেয়ার ডিপ';

  @override
  String get exChairDipPosition =>
      'পেছনে মজবুত চেয়ারের কিনারায় হাত, পা সামনে।';

  @override
  String get exChairDipStep1 => 'হাত সোজা রেখে শুরু করুন।';

  @override
  String get exChairDipStep2 => 'কনুই ভাঁজ করে শরীর নামান।';

  @override
  String get exChairDipStep3 => 'হাত সোজা না হওয়া পর্যন্ত ওপরে ঠেলুন।';

  @override
  String get exChairDipTip => 'পিঠ চেয়ারের কাছে রাখুন, কাঁধ নিচু।';

  @override
  String get exChairDipBenefit => 'হাতের পেছনের পেশি শক্ত করে।';

  @override
  String get exStepUpName => 'স্টেপ-আপ';

  @override
  String get exStepUpPosition =>
      'মজবুত সিঁড়ি বা নিচু বেঞ্চের দিকে মুখ করে দাঁড়ান।';

  @override
  String get exStepUpStep1 => 'গোড়ালিতে চাপ দিয়ে এক পা দিয়ে ওপরে উঠুন।';

  @override
  String get exStepUpStep2 => 'অন্য পা তুলে সোজা দাঁড়ান।';

  @override
  String get exStepUpStep3 => 'নেমে এসে সামনের পা বদলান।';

  @override
  String get exStepUpTip => 'নড়ে না এমন সিঁড়ি নিন; দরকার হলে দেয়াল ধরুন।';

  @override
  String get exStepUpBenefit => 'পা শক্ত করে, সিঁড়ি ভাঙতে সাহায্য করে।';

  @override
  String get exCalfRaiseName => 'কাফ রেইজ';

  @override
  String get exCalfRaisePosition =>
      'সোজা দাঁড়ান, পা কোমরের সমান ফাঁকে, ভারসাম্যের জন্য দেয়াল ধরুন।';

  @override
  String get exCalfRaiseStep1 => 'পায়ের সামনের অংশে ভর দিয়ে উঁচু হন।';

  @override
  String get exCalfRaiseStep2 => 'ওপরে একটু থামুন।';

  @override
  String get exCalfRaiseStep3 => 'ধীরে গোড়ালি নামান।';

  @override
  String get exCalfRaiseTip => 'ধীরে করুন; লাফাবেন না।';

  @override
  String get exCalfRaiseBenefit => 'পায়ের পেছনের পেশি ও গোড়ালি শক্ত করে।';

  @override
  String get exDeadBugName => 'ডেড বাগ';

  @override
  String get exDeadBugPosition =>
      'চিত হয়ে শুয়ে হাত ওপরে, হাঁটু কোমরের ওপর ৯০° ভাঁজ।';

  @override
  String get exDeadBugStep1 => 'কোমরের নিচের অংশ মেঝেতে চেপে রাখুন।';

  @override
  String get exDeadBugStep2 => 'এক হাত ও বিপরীত পা মেঝের দিকে নামান।';

  @override
  String get exDeadBugStep3 => 'ফিরে এসে পাশ বদলান।';

  @override
  String get exDeadBugTip => 'পুরো সময় কোমরের নিচের অংশ মেঝেতে রাখুন।';

  @override
  String get exDeadBugBenefit => 'পিঠে কম চাপ দিয়ে পেটের নিয়ন্ত্রণ বাড়ায়।';

  @override
  String get exGobletSquatName => 'গবলেট স্কোয়াট';

  @override
  String get exGobletSquatPosition =>
      'একটি ডাম্বেল বুকের সামনে খাড়া করে ধরুন, পা কাঁধের সমান ফাঁকে।';

  @override
  String get exGobletSquatStep1 => 'কনুই নিচের দিকে রেখে সোজা দাঁড়ান।';

  @override
  String get exGobletSquatStep2 => 'কোমর পেছনে নিয়ে স্কোয়াট করুন।';

  @override
  String get exGobletSquatStep3 => 'গোড়ালিতে চাপ দিয়ে উঠে দাঁড়ান।';

  @override
  String get exGobletSquatTip => 'বুক উঁচু রাখুন, ওজন শরীরের কাছে।';

  @override
  String get exGobletSquatBenefit => 'বাড়তি ওজনে পা ও নিতম্বের শক্তি বাড়ায়।';

  @override
  String get exDumbbellRowName => 'ডাম্বেল রো';

  @override
  String get exDumbbellRowPosition =>
      'এক হাত ও হাঁটু বেঞ্চ বা চেয়ারে, অন্য হাতে ডাম্বেল, পিঠ সমান।';

  @override
  String get exDumbbellRowStep1 => 'হাত সোজা নিচে ঝুলতে দিন।';

  @override
  String get exDumbbellRowStep2 => 'ডাম্বেল কোমরের দিকে টেনে তুলুন।';

  @override
  String get exDumbbellRowStep3 => 'ধীরে নামান।';

  @override
  String get exDumbbellRowTip => 'পিঠ সমান রাখুন, মোচড়াবেন না।';

  @override
  String get exDumbbellRowBenefit =>
      'পিঠের ওপরের অংশ শক্ত করে ও ভঙ্গি ঠিক রাখে।';

  @override
  String get exShoulderPressName => 'শোল্ডার প্রেস';

  @override
  String get exShoulderPressPosition =>
      'সোজা বসুন বা দাঁড়ান, ডাম্বেল কাঁধের উচ্চতায়, হাতের তালু সামনে।';

  @override
  String get exShoulderPressStep1 => 'পেট শক্ত করুন।';

  @override
  String get exShoulderPressStep2 => 'ডাম্বেল সোজা মাথার ওপরে ঠেলুন।';

  @override
  String get exShoulderPressStep3 => 'আবার কাঁধে নামান।';

  @override
  String get exShoulderPressTip => 'পিঠ বাঁকাবেন না; পাঁজর নিচে রাখুন।';

  @override
  String get exShoulderPressBenefit =>
      'মাথার ওপরে তোলার জন্য কাঁধ ও হাতের শক্তি বাড়ায়।';

  @override
  String get exRomanianDeadliftName => 'রোমানিয়ান ডেডলিফট';

  @override
  String get exRomanianDeadliftPosition =>
      'উরুর সামনে ডাম্বেল ধরে দাঁড়ান, হাঁটু একটু ভাঁজ।';

  @override
  String get exRomanianDeadliftStep1 => 'পিঠ সমান, কাঁধ পেছনে রাখুন।';

  @override
  String get exRomanianDeadliftStep2 => 'কোমর পেছনে নিয়ে পা বরাবর ওজন নামান।';

  @override
  String get exRomanianDeadliftStep3 => 'নিতম্ব শক্ত করে উঠে দাঁড়ান।';

  @override
  String get exRomanianDeadliftTip => 'কোমর থেকে ঝুঁকুন; পিঠ সোজা থাকে।';

  @override
  String get exRomanianDeadliftBenefit => 'পায়ের পেছন ও নিতম্ব শক্ত করে।';

  @override
  String get exBicepCurlName => 'বাইসেপস কার্ল';

  @override
  String get exBicepCurlPosition =>
      'সোজা দাঁড়ান, দুপাশে ডাম্বেল, হাতের তালু সামনে।';

  @override
  String get exBicepCurlStep1 => 'কনুই শরীরের কাছে রাখুন।';

  @override
  String get exBicepCurlStep2 => 'ওজন কাঁধের দিকে ভাঁজ করে তুলুন।';

  @override
  String get exBicepCurlStep3 => 'ধীরে নামান।';

  @override
  String get exBicepCurlTip => 'দোলাবেন না; শুধু হাতের নিচের অংশ নড়বে।';

  @override
  String get exBicepCurlBenefit => 'হাতের সামনের পেশি শক্ত করে।';

  @override
  String get exBandRowName => 'ব্যান্ড রো';

  @override
  String get exBandRowPosition =>
      'পা সোজা করে বসুন, পায়ে ব্যান্ড পেঁচিয়ে দুই প্রান্ত হাতে।';

  @override
  String get exBandRowStep1 => 'হাত সোজা রেখে সোজা হয়ে বসুন।';

  @override
  String get exBandRowStep2 =>
      'কাঁধের হাড় চেপে প্রান্তগুলো কোমরের দিকে টানুন।';

  @override
  String get exBandRowStep3 => 'ধীরে ফিরে যান।';

  @override
  String get exBandRowTip => 'পিঠ সোজা রাখুন; পেছনে হেলবেন না।';

  @override
  String get exBandRowBenefit =>
      'হালকা, জয়েন্টবান্ধব প্রতিরোধে পিঠের ওপরের অংশ শক্ত করে।';

  @override
  String get exBandPullApartName => 'ব্যান্ড পুল-অ্যাপার্ট';

  @override
  String get exBandPullApartPosition =>
      'সোজা দাঁড়ান, কাঁধের উচ্চতায় সামনে ব্যান্ড ধরুন।';

  @override
  String get exBandPullApartStep1 => 'হাত সোজা রাখুন।';

  @override
  String get exBandPullApartStep2 =>
      'বুকে না লাগা পর্যন্ত ব্যান্ড দুদিকে টানুন।';

  @override
  String get exBandPullApartStep3 => 'ধীরে ফিরে যান।';

  @override
  String get exBandPullApartTip => 'কাঁধের হাড় চাপুন; কাঁধ নিচে রাখুন।';

  @override
  String get exBandPullApartBenefit =>
      'পিঠের ওপরের অংশ ও কাঁধ শক্ত করে, ভঙ্গি ঠিক রাখে।';

  @override
  String get exLegPressName => 'লেগ প্রেস';

  @override
  String get exLegPressPosition =>
      'মেশিনে বসুন, পিঠ প্যাডে সমান, পা প্ল্যাটফর্মে কাঁধের সমান ফাঁকে।';

  @override
  String get exLegPressStep1 => 'সেফটি খুলে হাতল ধরুন।';

  @override
  String get exLegPressStep2 => 'হাঁটু ভাঁজ করে প্ল্যাটফর্ম নিজের দিকে নামান।';

  @override
  String get exLegPressStep3 => 'পা প্রায় সোজা না হওয়া পর্যন্ত ঠেলে দিন।';

  @override
  String get exLegPressTip => 'ওপরে হাঁটু পুরো লক করবেন না।';

  @override
  String get exLegPressBenefit => 'পিঠে সাপোর্ট রেখে পায়ের শক্তি বাড়ায়।';

  @override
  String get exLatPulldownName => 'ল্যাট পুলডাউন';

  @override
  String get exLatPulldownPosition =>
      'উরু প্যাডের নিচে রেখে বসুন, কাঁধের চেয়ে চওড়া করে বার ধরুন।';

  @override
  String get exLatPulldownStep1 => 'সোজা বসে একটু পেছনে হেলুন।';

  @override
  String get exLatPulldownStep2 => 'বার বুকের ওপরের অংশ পর্যন্ত টেনে নামান।';

  @override
  String get exLatPulldownStep3 =>
      'হাত সোজা না হওয়া পর্যন্ত ধীরে ওপরে যেতে দিন।';

  @override
  String get exLatPulldownTip => 'কনুই দিয়ে টানুন; ঘাড়ের পেছনে টানবেন না।';

  @override
  String get exLatPulldownBenefit => 'টানার জন্য পিঠ ও হাত শক্ত করে।';

  @override
  String get exSeatedCableRowName => 'সিটেড কেবল রো';

  @override
  String get exSeatedCableRowPosition =>
      'কেবল মেশিনে বসুন, পা প্ল্যাটফর্মে, হাঁটু হালকা ভাঁজ, দুই হাতে হাতল।';

  @override
  String get exSeatedCableRowStep1 => 'হাত সোজা রেখে সোজা বসুন।';

  @override
  String get exSeatedCableRowStep2 => 'কাঁধের হাড় চেপে হাতল পেটের দিকে টানুন।';

  @override
  String get exSeatedCableRowStep3 => 'ধীরে ফিরে যান।';

  @override
  String get exSeatedCableRowTip => 'পিঠ সোজা রাখুন; দোলাবেন না।';

  @override
  String get exSeatedCableRowBenefit =>
      'পিঠের মাঝের অংশ শক্ত করে ও ভঙ্গি ঠিক রাখে।';

  @override
  String get exChestPressName => 'চেস্ট প্রেস';

  @override
  String get exChestPressPosition =>
      'প্যাডে পিঠ ঠেকিয়ে বসুন, হাতল বুকের উচ্চতায়।';

  @override
  String get exChestPressStep1 => 'কনুই ভাঁজ করে হাতল ধরুন।';

  @override
  String get exChestPressStep2 => 'হাত সোজা না হওয়া পর্যন্ত হাতল সামনে ঠেলুন।';

  @override
  String get exChestPressStep3 => 'ধীরে ফিরে যান।';

  @override
  String get exChestPressTip => 'কাঁধ প্যাডে পেছনে রাখুন।';

  @override
  String get exChestPressBenefit => 'নির্দিষ্ট পথে বুক ও হাতের শক্তি বাড়ায়।';

  @override
  String get exDumbbellBenchPressName => 'ডাম্বেল বেঞ্চ প্রেস';

  @override
  String get exDumbbellBenchPressPosition =>
      'সমান বেঞ্চে শুয়ে বুকের ওপরে ডাম্বেল, পা মেঝেতে।';

  @override
  String get exDumbbellBenchPressStep1 => 'হাত ওপরে সোজা রেখে শুরু করুন।';

  @override
  String get exDumbbellBenchPressStep2 => 'ডাম্বেল বুকের দুপাশে নামান।';

  @override
  String get exDumbbellBenchPressStep3 => 'আবার ওপরে ঠেলুন।';

  @override
  String get exDumbbellBenchPressTip => 'ওজন নিয়ন্ত্রণে রাখুন; কবজি সোজা।';

  @override
  String get exDumbbellBenchPressBenefit => 'বুক, কাঁধ ও হাতের শক্তি বাড়ায়।';

  @override
  String get exLegCurlName => 'লেগ কার্ল';

  @override
  String get exLegCurlPosition =>
      'মেশিনে বসুন বা শুয়ে পড়ুন, প্যাড গোড়ালির ঠিক ওপরে।';

  @override
  String get exLegCurlStep1 => 'হাতল ধরে কোমর নিচে রাখুন।';

  @override
  String get exLegCurlStep2 => 'হাঁটু ভাঁজ করে প্যাড নিজের দিকে আনুন।';

  @override
  String get exLegCurlStep3 => 'ধীরে ফিরে যান।';

  @override
  String get exLegCurlTip => 'মসৃণভাবে করুন; কোমর তুলবেন না।';

  @override
  String get exLegCurlBenefit => 'উরুর পেছনের পেশি শক্ত করে।';

  @override
  String get exTricepsPushdownName => 'ট্রাইসেপস পুশডাউন';

  @override
  String get exTricepsPushdownPosition =>
      'উঁচু কেবলের সামনে বার বা দড়ি নিয়ে দাঁড়ান, কনুই শরীরের পাশে।';

  @override
  String get exTricepsPushdownStep1 => 'কনুই ভাঁজ রেখে শুরু করুন।';

  @override
  String get exTricepsPushdownStep2 => 'হাত সোজা না হওয়া পর্যন্ত নিচে ঠেলুন।';

  @override
  String get exTricepsPushdownStep3 => 'হাতল ধীরে ওপরে উঠতে দিন।';

  @override
  String get exTricepsPushdownTip => 'কনুই শরীরের পাশে স্থির রাখুন।';

  @override
  String get exTricepsPushdownBenefit => 'হাতের পেছনের পেশি শক্ত করে।';

  @override
  String get exTreadmillInclineWalkName => 'ইনক্লাইন ট্রেডমিল হাঁটা';

  @override
  String get exTreadmillInclineWalkPosition =>
      'ট্রেডমিলে দাঁড়িয়ে হালকা ঢাল ও দ্রুত হাঁটার গতি ঠিক করুন।';

  @override
  String get exTreadmillInclineWalkStep1 => 'সামনে তাকিয়ে সোজা হয়ে হাঁটুন।';

  @override
  String get exTreadmillInclineWalkStep2 => 'স্বাভাবিকভাবে হাত দোলান।';

  @override
  String get exTreadmillInclineWalkStep3 =>
      'এমন গতিতে চলুন যাতে কথা বলা যায় কিন্তু গা গরম হয়।';

  @override
  String get exTreadmillInclineWalkTip =>
      'রেলিং শুধু ভারসাম্যের জন্য ধরুন, হেলে পড়তে নয়।';

  @override
  String get exTreadmillInclineWalkBenefit =>
      'জয়েন্টে কম চাপ দিয়ে হৃৎস্পন্দন বাড়ায়।';

  @override
  String get exStationaryBikeName => 'স্টেশনারি বাইক';

  @override
  String get exStationaryBikePosition =>
      'সিট এমনভাবে ঠিক করুন যাতে প্যাডেল নিচে গেলে হাঁটু একটু ভাঁজ থাকে।';

  @override
  String get exStationaryBikeStep1 => 'সোজা বসে হ্যান্ডেল হালকা করে ধরুন।';

  @override
  String get exStationaryBikeStep2 => 'স্থির, আরামদায়ক গতিতে প্যাডেল করুন।';

  @override
  String get exStationaryBikeStep3 => 'খুব সহজ লাগলে প্রতিরোধ বাড়ান।';

  @override
  String get exStationaryBikeTip => 'হাঁটু পায়ের সোজাসুজি রাখুন।';

  @override
  String get exStationaryBikeBenefit =>
      'জয়েন্টে কম চাপ দিয়ে হৃদ্‌যন্ত্রের সক্ষমতা বাড়ায়।';

  @override
  String get exRowingMachineName => 'রোয়িং মেশিন';

  @override
  String get exRowingMachinePosition =>
      'রোয়ারে বসুন, পা বাঁধা, দুই হাতে হাতল, হাত সোজা।';

  @override
  String get exRowingMachineStep1 => 'প্রথমে পা দিয়ে ঠেলুন।';

  @override
  String get exRowingMachineStep2 =>
      'একটু পেছনে হেলে হাতল পাঁজরের নিচ পর্যন্ত টানুন।';

  @override
  String get exRowingMachineStep3 =>
      'প্রথমে হাত, তারপর শরীর, তারপর পা ফিরিয়ে আনুন।';

  @override
  String get exRowingMachineTip => 'শক্তি আসে পা থেকে; পিঠ সোজা রাখুন।';

  @override
  String get exRowingMachineBenefit =>
      'পা, পিঠ ও হৃদ্‌যন্ত্রের জন্য পুরো শরীরের কার্ডিও।';

  @override
  String get muscleChest => 'বুক';

  @override
  String get muscleShoulders => 'কাঁধ';

  @override
  String get muscleTriceps => 'ট্রাইসেপস';

  @override
  String get muscleBiceps => 'বাইসেপস';

  @override
  String get muscleBack => 'পিঠ';

  @override
  String get muscleCore => 'পেটের পেশি';

  @override
  String get muscleGlutes => 'নিতম্ব';

  @override
  String get muscleQuads => 'উরুর সামনে';

  @override
  String get muscleHamstrings => 'উরুর পেছনে';

  @override
  String get muscleCalves => 'পায়ের ডিম';

  @override
  String get muscleFullBody => 'পুরো শরীর';

  @override
  String get muscleHeart => 'হৃদ্‌যন্ত্র ও ফুসফুস';

  @override
  String get exMarchInPlaceName => 'জায়গায় মার্চ';

  @override
  String get exMarchInPlacePosition =>
      'সোজা দাঁড়ান, পা কোমরের সমান ফাঁকে, হাত আলগা।';

  @override
  String get exMarchInPlaceStep1 => 'আরামদায়ক উচ্চতায় এক হাঁটু তুলুন।';

  @override
  String get exMarchInPlaceStep2 => 'সেটি নামিয়ে হাত দুলিয়ে অন্যটি তুলুন।';

  @override
  String get exMarchInPlaceStep3 =>
      'নির্ধারিত সময় ধরে দ্রুত, স্থির ছন্দে চালিয়ে যান।';

  @override
  String get exMarchInPlaceTip =>
      'আলতো করে পা ফেলুন; যতটা আরাম লাগে ততটাই হাঁটু তুলুন।';

  @override
  String get exMarchInPlaceBenefit =>
      'কম ধাক্কার কার্ডিও, হৃৎস্পন্দন ধীরে বাড়ায়।';

  @override
  String planDay(String letter) {
    return 'দিন $letter';
  }

  @override
  String planFullBody(String letter) {
    return 'পুরো শরীর $letter';
  }

  @override
  String planUpperBody(String letter) {
    return 'ওপরের শরীর $letter';
  }

  @override
  String planLowerBody(String letter) {
    return 'নিচের শরীর $letter';
  }

  @override
  String get planFocusFullBody => 'পা, ঠেলা, টানা, পেট ও কার্ডিও';

  @override
  String get planFocusUpperBody => 'বুক, পিঠ, কাঁধ ও হাত';

  @override
  String get planFocusLowerBody => 'পা, নিতম্ব ও পেট';

  @override
  String rulesPlanSummary(int count) {
    return 'সপ্তাহে $countটি ওয়ার্কআউট, আপনার প্রোফাইল থেকে ফোনেই তৈরি।';
  }

  @override
  String get exerciseSetupTitle => 'ব্যায়ামের সেটআপ';

  @override
  String get exerciseIntroTitle => 'আপনি কোথায় ব্যায়াম করেন?';

  @override
  String get exerciseIntroBody =>
      'একটি বেছে নিন, আমরা আপনার প্রোফাইল ও লক্ষ্য অনুযায়ী সাপ্তাহিক পরিকল্পনা বানাব। যেকোনো সময় বদলাতে পারবেন।';

  @override
  String get envHome => 'বাসায় ব্যায়াম';

  @override
  String get envHomeDesc =>
      'শরীরের ওজনে ব্যায়াম, জিম লাগবে না। ডাম্বেল বা ব্যান্ড থাকলে যোগ করুন।';

  @override
  String get envGym => 'জিমে ব্যায়াম';

  @override
  String get envGymDesc => 'মেশিন, ডাম্বেল ও কার্ডিও সরঞ্জাম।';

  @override
  String get setupExtras => 'নিজের মতো করুন (ঐচ্ছিক)';

  @override
  String get setupExtrasHint => 'নিশ্চিত না হলে যেমন আছে রেখে দিন।';

  @override
  String get setupLevel => 'ফিটনেসের মাত্রা';

  @override
  String get levelBeginner => 'শুরু করছি';

  @override
  String get levelIntermediate => 'মাঝারি';

  @override
  String get levelAdvanced => 'অভিজ্ঞ';

  @override
  String get setupMinutes => 'প্রতি ওয়ার্কআউটে মিনিট';

  @override
  String minutesShort(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get setupEquipment => 'বাসায় যে সরঞ্জাম আছে';

  @override
  String get equipDumbbells => 'ডাম্বেল';

  @override
  String get equipBands => 'রেজিস্ট্যান্স ব্যান্ড';

  @override
  String get setupLimitations => 'যেসব জায়গায় সাবধান';

  @override
  String get setupLimitationsHint =>
      'এসব জায়গায় চাপ দেয় এমন ব্যায়াম বাদ দেওয়া হবে।';

  @override
  String get limitKnees => 'হাঁটু';

  @override
  String get limitLowerBack => 'কোমরের নিচের অংশ';

  @override
  String get limitShoulders => 'কাঁধ';

  @override
  String get limitWrists => 'কবজি';

  @override
  String get setupSafety =>
      'এটি সাধারণ ফিটনেস পরামর্শ, চিকিৎসা পরামর্শ নয়। কোনো অসুখ বা আঘাত থাকলে আগে ডাক্তারের সাথে কথা বলুন, আর কোনো ব্যায়ামে ব্যথা হলে থামুন।';

  @override
  String get createPlan => 'আমার পরিকল্পনা বানান';

  @override
  String get updatePlan => 'পরিকল্পনা হালনাগাদ করুন';

  @override
  String get creatingPlan => 'আপনার পরিকল্পনা তৈরি হচ্ছে…';

  @override
  String get regeneratePlan => 'নতুন পরিকল্পনা বানান';

  @override
  String get regenerateTitle => 'নতুন পরিকল্পনা বানাবেন?';

  @override
  String get regenerateBody =>
      'বর্তমান পরিকল্পনা বদলে যাবে। যেসব ওয়ার্কআউট করেছেন সেগুলো ইতিহাসে থাকবে।';

  @override
  String get planMadeOffline =>
      'AI-এর সাথে যোগাযোগ না হওয়ায় AI ছাড়া বানানো হয়েছে। আপনার জন্য AI-এর লেখা পরিকল্পনা পেতে আবার চেষ্টা করুন।';

  @override
  String get planTryAi => 'আবার AI দিয়ে চেষ্টা';

  @override
  String get planOutdated =>
      'এই পরিকল্পনা বানানোর পর আপনার প্রোফাইল বা সেটআপ বদলেছে।';

  @override
  String get planUpdate => 'হালনাগাদ করুন';

  @override
  String get todaysWorkout => 'আজকের ওয়ার্কআউট';

  @override
  String progressDone(int done, int total) {
    return '$totalটির মধ্যে $doneটি শেষ';
  }

  @override
  String get statExercises => 'ব্যায়াম';

  @override
  String get statDone => 'শেষ';

  @override
  String get statLeft => 'বাকি';

  @override
  String get statTime => 'মিনিট';

  @override
  String get statKcal => 'আনুমানিক kcal';

  @override
  String aboutMinutes(int minutes) {
    return '≈ $minutes মিনিট';
  }

  @override
  String aboutKcal(int kcal) {
    return '≈ $kcal kcal';
  }

  @override
  String setsCount(int count) {
    return '$count সেট';
  }

  @override
  String repsCount(int count) {
    return '$count বার';
  }

  @override
  String secondsShort(int seconds) {
    return '$seconds সে.';
  }

  @override
  String setsTimesReps(int sets, String reps) {
    return '$sets × $reps';
  }

  @override
  String get statusNotStarted => 'শুরু হয়নি';

  @override
  String get statusInProgress => 'চলছে';

  @override
  String get statusCompleted => 'শেষ';

  @override
  String get kcalDisclaimer =>
      'ক্যালরি মোটামুটি হিসাব (প্রায়ই ৩০% বা তার বেশি কমবেশি)। চর্বি কমা নির্ভর করে সপ্তাহজুড়ে আপনার খাওয়া ও সক্রিয়তার ওপর, একক ব্যায়ামের ওপর নয়।';

  @override
  String exerciseCardLabel(String name, String detail, String status) {
    return '$name: $detail, $status';
  }

  @override
  String get workoutSetupTooltip => 'ব্যায়ামের সেটআপ';
}
