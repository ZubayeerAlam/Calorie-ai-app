# Cal AI — Feature Plan & Roadmap

What we have built and what comes next. For a detailed description of the app as it stands, see [build.md](build.md).

**How we work on each feature**
1. **Plan:** write the plan first and agree on it before coding.
2. **Build:** each UI component is its own widget in its own file.
3. **Test:** add or update tests; `flutter analyze` and `flutter test` must pass.
4. **Record:** update [build.md](build.md) and tick the feature off here.

Status: ✅ done · 🟡 partly done or needs follow-up · ⬜ not started

---

## 📌 Decisions for the next phase

These are agreed and will be built later, in the order shown under "Suggested order" at the bottom.

1. **Firebase is added by you.** When we reach that step you set up Firebase yourself (project, config files, packages, rules). Until then we only prepare the app so Firebase can be plugged in. See feature 15.
2. **The Insights tab is removed** from the bottom bar. Its charts move into Tracker (see feature 17).
3. **A camera button is added to the bottom bar** (centre). Tapping it opens a chooser with **two options**:
   - **Camera:** take or upload a photo of the food, and AI analyses it.
   - **Manual:** describe the food and details by hand, and AI generates the nutrition data.
4. **The bottom bar becomes:** Home · Tracker · 📷 Camera (centre action, not a tab) · Account. (Articles was dropped on 2026-11-02.)
   - **Changed 2026-11-12 (feature 23):** Home · Tracker · 📷 Camera · **Exercise** · Account. The camera now sits inside the bar instead of rising above it.

---

## ✅ Completed

### 1. Project setup ✅
- Feature-first folder structure, `provider` for state.
- Camera and gallery through `image_picker`, permissions through `permission_handler`.
- Services wrap the plugins, so features and tests don't depend on the plugins directly.

### 2. Onboarding UI ✅
- 10 steps: name, gender, birthday, height, weight, goal, activity, diet, dinner time, plan.
- Built to match the mockups:
  - shared header (back arrow, progress bar, "n / 10");
  - Continue button, disabled until the step is complete;
  - custom scroll wheel, weight ruler, option cards, kg/lb toggle.
- Outfit font and the green brand colour.

### 3. Navigation with go_router ✅
- Every screen opens through go_router.
- Onboarding redirect: users without a saved profile are sent to `/onboarding`.
- 5 bottom tabs (Home, Tracker, Insights, Articles, Account). Each tab remembers its own screen.

### 4. Local storage (shared_preferences) ✅
- Profile, goals and food log are saved on the device.
- Returning users skip onboarding.
- Unreadable saved data is cleared safely instead of crashing the app.

### 5. Personalizing loader ✅
- After the last setup step: "Personalizing your Cal AI experience…", with a ring filling 0–100%.
- Then the plan page (calories, macros, kg per week).

### 6. Calorie engine — your "Phase 1" spec ✅
- `lib/core/utils/calorie_calculator.dart`.
- Mifflin-St Jeor BMR → activity multiplier (TDEE) → ±500 kcal for the goal (minimum 1200) → macros 50/30/20.

### 7. Home dashboard ✅
- Built from the mockup:
  - date selector;
  - Eaten / kcal-left ring / Burned;
  - macro rings;
  - Burned section;
  - meal rows (30/30/30/10 split).
- Meal ＋ opens Add Food with that meal chosen; tapping a meal lists its entries, with delete.
- Activity calories entered by hand and saved per day.
- Scan moved into Add Food ("Scan a photo").

### 8. User info on Home ✅
- Greeting with the user's name and initials avatar; goal and daily kcal in the header.
- Profile card: goal, weight, height, age, BMI, in metric or imperial units.
- "Your calorie plan" card showing how the target was calculated, step by step.

### 9. Goal sync ✅
- Targets are recalculated from the saved profile on every launch.
- If changed by hand on Account, they're kept; "Reset to recommended" undoes that.
- The Account slider re-splits macros 50/30/20.

### 10. Eaten / Burned improvements ✅
- **Macro estimates:** if only calories are entered, macros are estimated and marked "(est.)".
- **Steps:**
  - `pedometer` feeds Walking calories into Burned.
  - Daily steps are saved; a new day and a phone restart are handled.
  - Android and iOS permissions are set up.
- **Hint:** a "Nothing logged yet" note on Home while nothing is logged.

---

## 🟡 Follow-ups for what's built

- [x] **Commit all files.** The latest commit imports about 30 files that aren't in git yet, so a fresh clone won't build. Run `git add lib test cal-ai-build` and commit.
- [ ] **Test on a real phone.** Especially steps (the simulator has no step sensor), camera and gallery, and the permission prompts.
- [x] **Save the dinner time.** Done: it's now stored in the profile (`dinnerHour`, `dinnerMinute`) and has a "8:30 PM" label ready for reminders (see 18). Profiles saved before this change get the default 8:30 PM instead of failing to load.
- [x] **Check iOS permission setup.** Checked: no change needed. This project builds with Swift Package Manager (that's why there is no Podfile), and `permission_handler` switches permissions on from the usage descriptions in `Info.plist`. The build resolves camera, photos and motion to enabled.
- [x] **Onboarding goal: multi-select.** Done: the goal step now has all six options from the mockup. The three weight goals (Lose, Maintain, Gain weight) exclude each other and set the calorie target. The focus goals (Gain muscle, Boost energy, Improve nutrition) can be combined freely and don't change the target. They are saved in the profile and shown as chips on Home.
- [ ] **Decide what the focus goals do.** For now they are saved and shown only. Feature 23 will use Gain muscle and Boost energy to shape the workout plan (the calorie targets stay unchanged). Ideas: Gain muscle could raise the protein share, Boost energy could add reminders, Improve nutrition could add food tips. Say which, if any, you want.

---

## ⬜ Future features

### 11. Bottom bar: remove Insights, add the camera button ✅
- **Goal:** the new bar from decision 4. No Firebase needed.
- **Done:** Insights is gone (route, tab and placeholder). The bar has Home, Tracker, Articles and Account, with a raised green camera button in the middle. The button is an action, so it doesn't change the page behind it.
- The camera button opens the two-option chooser (feature 12).
- **Changed 2026-11-12 (feature 23):** the camera no longer rises above the bar; it is a 52 px button in the bar's middle slot, with Exercise added to the right.
- **Original tasks:**
- **Tasks:**
  - Remove the Insights tab: its route `/insights` in `app_router.dart`, its item in `app_bottom_nav.dart`, and its placeholder.
  - Add a raised, centre camera button. It is an action, not a tab, so it doesn't change the page behind it; it opens the chooser (feature 12).
  - Keep the other tabs as they are: Home, Tracker, Articles, Account.
  - Update the tests that look for the five tabs.

### 12. Camera chooser: two ways to add food ✅
- **Goal:** tapping the camera button opens a bottom sheet with two options.
  - **Scan with camera:** take a photo of the food, or pick one from the gallery.
  - **Add manually:** enter the food details by hand.
- **Done:**
  - The chooser sheet (`AddFoodChooserSheet`) with two option cards (`AddFoodOptionCard`). Dismiss it and nothing changes.
  - **Scan with camera** opens the Scan screen. After "Use this photo", Add Food opens with the photo attached (Scan is replaced, so Back returns to the tab you came from).
  - **Add manually** opens the Add Food form.
  - Add Food's own "Scan a photo" button still works as before: the photo goes back to the same form.
  - `/scan` has two modes (`?returnPhoto=true` hands the photo back; without it, Add Food is opened with the photo).
  - A missing or unreadable photo shows a placeholder instead of an error.
- **Changed from the original plan:** no separate `/add-manually` route yet. The manual option opens the existing Add Food form. The `/add-manually` screen (description plus optional details, AI-generated nutrition) is built in feature 14, and the current form stays as "Enter numbers myself".
- **Works without AI:** nothing here needs Firebase. Features 13 and 14 add the AI analysis behind these two options.

### 13. AI analysis of a food photo (camera option) ✅ real AI
- **Goal:** from a photo, the AI returns what the food is and its nutrition, then the user reviews and saves.
- **Flow (working now):**
  1. Camera button → **Scan with camera** → take or pick a photo → **Use this photo**.
  2. The `/analyze-food` screen shows the photo with "Analyzing your meal…".
  3. The result lists each item with name, portion, calories, protein, carbs and fat.
  4. Every field can be edited and items removed. The meal is suggested from the time of day (before 10:00 breakfast, before 15:00 lunch, before 17:00 snacks, before 22:00 dinner, otherwise snacks) and can be changed.
  5. **Add to <meal> · <total> kcal** saves one food log entry per item on the day shown on Home, with the photo, marked "(AI estimate)".
- **If it fails:**
  - **No food found:** "Try another photo" (back to Scan) or "Enter it manually" (Add Food with the photo kept).
  - **No connection / something went wrong:** "Try again" or "Enter it manually".
- **Built:**
  - `FoodAnalysisService` interface and `FoodAnalysisException` (`lib/core/services/food_analysis_service.dart`).
  - `FoodAnalysis` / `AnalyzedFoodItem` models with strict parsing of the AI reply (`lib/features/food_scan/data/models/food_analysis.dart`). Expected reply shape: `{ "isFood": true, "items": [ { "name", "portion", "calories", "protein", "carbs", "fat" } ] }`.
  - `FoodAnalysisController` (one per screen) and the screen widgets: loading, review, error, editable item card, meal picker, demo notice.
  - `FoodEntry` now stores `aiEstimated` and `portion` (older entries load with none).
- **Real AI (2026-11-02):** `FirebaseFoodAnalysisService` (`lib/core/services/firebase_food_analysis_service.dart`) sends the photo to Gemini (`gemini-3.5-flash-lite`, set in `AppConstants.foodAnalysisModel`) through Firebase AI Logic, asks for JSON in the reply shape above (response schema, temperature 0.2), and parses it with `FoodAnalysis.fromJson`. Errors map to `FoodAnalysisFailure` (no connection or a 45 s timeout → network; empty or non-JSON reply → invalidResponse). `main.dart` passes it to `CalAiApp(foodAnalysis: …)`.
- **Photo size:** the picker resizes photos to at most 1600 px (`AppConstants.imageMaxDimension`, quality 80), which keeps the AI request small.
- **Demo service kept for tests:** `DemoFoodAnalysisService` is still the default in `CalAiApp`, so widget tests never call the real AI.
- **Not yet checked:** a real photo on the emulator (the text flow, feature 14, was checked end to end).

### 14. AI from manually entered details (manual option) ✅ real AI
- **Goal:** the user types the food details and the AI generates the nutrition data.
- **Flow (working now):**
  1. Camera button → **Add manually** → the `/add-manually` screen: "What did you eat?" (e.g. "2 scrambled eggs, toast with butter, black coffee").
  2. Optional details: portion size, cooking method, brand or restaurant, ingredients.
  3. **Analyze with AI** opens the same analysis screen as photos: loading, then a review showing "You described" (the text and details) instead of a photo.
  4. Same review as feature 13: edit any value, remove items, pick the meal, **Add to <meal>**. Entries are marked "(AI estimate)" and have no photo.
  5. After saving, both screens close and you're back on the tab. Pressing Back from the review returns to the form with your text kept, so you can edit it.
- **If it fails:** "No food recognised" offers **Edit description** (back to the form) or **Enter numbers myself**; other errors offer **Try again**.
- **"Enter numbers myself":** a link on the manual screen (and on the error screen) opens the classic Add Food form, replacing the manual screen.
- **Built:**
  - `FoodDescription` model (`lib/features/food_scan/data/models/food_description.dart`) and `analyzeText()` on `FoodAnalysisService`.
  - `AnalysisRequest` (photo or text) so `FoodAnalysisController` and all analysis screens are shared by both flows.
  - `ManualEntryScreen`, `DetailField`, `DescriptionSummary`.
- **Real AI (2026-11-02):** `FirebaseFoodAnalysisService.analyzeText` sends the description and details to Gemini. Checked on the Android emulator: "2 scrambled eggs, 1 slice buttered toast, tea with milk" → 3 items (148 + 135 + 20 kcal = 303 kcal) with portions and macros.

### 15. Firebase — you implement this 🟡 one Console step left (checked 2026-11-02)
- **Who:** you set up Firebase yourself. I don't add Firebase packages or config.
- **Firebase project:** `cal-ai-app-c32f8`.

**Status**
- [x] Firebase project created.
- [x] `flutterfire configure` run. It registered apps for Android, iOS, web and Windows, and created `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, `macos/Runner/GoogleService-Info.plist` and `firebase.json`. The Android Google Services plugin (`com.google.gms.google-services` 4.4.4) was added to `android/settings.gradle.kts` and `android/app/build.gradle.kts`.
- [x] **Add `firebase_core`** (`^5.1.0`). The analyzer errors in `lib/firebase_options.dart` are gone.
- [x] **Initialise Firebase** in `lib/main.dart`, before `LocalStorageService.init()`. Tests are unaffected (they build `CalAiApp` directly and never run `main()`).
- [x] **Run on Android:** checked on the Android 17 emulator (Pixel 10a). The log shows `FirebaseApp initialization successful`, and the app opens normally with the saved profile.
- [ ] **Run on iOS:** run once on the iOS simulator (the first build downloads the Firebase SDK and takes a few minutes).
- [x] **Cloud Firestore:** the `(default)` database is in **`asia-south1` (Mumbai)**, with the per-user rules from [`firestore.rules`](../firestore.rules) published (`firebase deploy --only firestore:rules`). (A first deploy auto-created it in `nam5`; it was deleted while empty and recreated in Mumbai.)
- [ ] **Authentication (you):** Console → Authentication → Sign-in method → enable **Email/Password**. Until then, sign-in shows "Email sign-in isn't turned on for this app yet."
- [x] **Sign-in, log out and cloud sync (code, 2026-11-02):** built, tested with fakes, and checked end to end on the Android emulator against the **local Firebase emulators** (real SDK and the same security rules): create account → profile, targets, weight log and meals in Firestore → log out (phone cleared) → sign in from onboarding → everything restored. How to repeat it: [emulator-testing.md](emulator-testing.md). Not yet tried against the real project (needs Email/Password turned on).
- [x] **Firebase AI Logic:** enabled with the Gemini Developer API; the app uses it through `firebase_ai` (`^5.1.0`).
- [x] **App Check** (`firebase_app_check` `^0.5.1`): enforced for AI Logic, so only this app can call the AI. Activated in `main.dart` after `Firebase.initializeApp`:
  - Debug builds use the debug provider. The emulator's debug token is registered as "Pixel emulator" on the Android app. A new device or a reinstall prints a new token in the log (`DebugAppCheckProvider`); register it with `firebase appcheck:debugtokens:create <token> --display-name "<name>" --project cal-ai-app-c32f8 --app <app id>`.
  - Release builds use Play Integrity (Android) and App Attest with DeviceCheck fallback (iOS).
  - The debug SHA-256 fingerprint was added to the Android app in Project settings.
- [ ] **Commit** the new config files together with the Gradle and Xcode project changes.

**Accounts and sync (built 2026-11-02)**
- **Optional:** the app works without an account, as before. Packages: `firebase_auth` `^7.0.1`, `cloud_firestore` `^7.1.0`.
- **Where to sign in:**
  - Account tab → "Back up your data" → **Sign in or create account** (`/sign-in`): email and password, "Forgot password?", and a switch between sign-in and create account.
  - First onboarding step → **Already have an account? Sign in**, to restore an account on a new phone; a restored profile skips onboarding.
- **Signed in:** the Account card shows the email, "Backed up and synced to your account", and **Log out**. Logging out asks first, then clears this phone and returns to onboarding; the data stays in the account.
- **How sync works** (`SyncService`, `lib/features/account/data/sync_service.dart`):
  - Local storage stays the source the app reads (works offline). Every local change is copied to Firestore; offline writes are sent later.
  - Firestore layout: `users/{uid}/data/{storageKey}` (profile, goals, activity, weight log, steps) and `users/{uid}/food_entries/{id}`.
  - **Signing in merges:** food entries are combined by id; day-by-day logs are merged per day (the cloud wins on the same day); profile and targets come from the cloud if it has them. What's on this phone is uploaded, so nothing is lost when you create an account.
  - At app start a signed-in user is merged again (or just keeps syncing if offline).
  - If the backup can't be read during sign-in (offline, or Firestore not created), sign-in is undone with a clear message.
- **Not synced:** device-only data (the step sensor baseline, Health imports, the Health switch) and meal photos (only the file path is stored, so photos show a placeholder on another phone).
- **Known limitation:** an entry deleted on one phone comes back from another phone that still has it, the next time that phone connects.

**Notes**
- **App IDs:** the apps were registered with the default IDs, `com.example.cal_ai_app` (Android) and `com.example.calAiApp` (iOS). That's fine for development, but the Play Store rejects `com.example`, so before publishing you'll change the ID and run `flutterfire configure` again.
- **Extra platforms:** web and Windows were also registered, and a macOS config file was written. The app only targets Android and iOS; these are harmless and can stay or be removed from the Console.
- **Before release (App Check):** add the Play Console **app signing** SHA-256 to the Android app, register App Attest for the iOS app, and delete the debug tokens. Without this, release builds get "App Check token is invalid" from the AI.
- **Debug tokens are secrets:** never put one in code or commit it.
- **Cloud Storage** (photo sync) is optional and needs the Blaze plan; not needed for AI analysis.

**When you're done, tell me and we will:**
- ~~connect `FoodAnalysisService` to the real AI~~ ✅ done (features 13 and 14);
- ~~add sign-in screens and logout~~ ✅ built (see "Accounts and sync");
- ~~connect the repositories to Firestore and move existing on-device data to the account~~ ✅ built.

**Prepared beforehand:** every data class is behind a repository (`FoodLogRepository`, `ActivityLogRepository`, `StepLogRepository`, `ProfileProvider`), and the AI is behind `FoodAnalysisService`, so each backend swap is contained.

### 16. Apple Health / Health Connect ✅ (2026-11-02)
- **Goal:** accurate steps for the whole day, and imported workouts for the Activity number.
- **Built:**
  - `health` `^13.3.2` behind `HealthService` (`lib/core/services/health_service.dart`); tests use `FakeHealthService`.
  - **Account tab → Health Connect / Apple Health card:** Connect asks for read access to steps and workouts (Android also calorie records). Then the last 30 days are imported, and the last 7 days again on every app start, return to the app, and Tracker open. Disconnect removes the imported numbers. On Android without Health Connect it offers **Install**.
  - **Steps:** a day's steps are the higher of the phone sensor (`pedometer`) and Health, so steps walked before opening the app now count.
  - **Workouts:** their calories are added to **Activity** on Home, next to what you log by hand (the Log activity sheet says "Plus N kcal from workouts in Health").
- **Platform setup:**
  - Android: `minSdk` 26; `READ_STEPS`, `READ_EXERCISE`, `READ_TOTAL_CALORIES_BURNED`; the Health Connect queries, permission-rationale intent filter and `ViewPermissionUsageActivity` alias in the manifest; `MainActivity` is now a `FlutterFragmentActivity`.
  - iOS: `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription` in `Info.plist`, and the HealthKit entitlement (`ios/Runner/Runner.entitlements`, linked in the Xcode project).
- **Checked:** on the Android emulator the Connect button opens Health Connect's permission screen, and "Don't allow" returns to Connect. Granting access with real data and iOS are not yet checked.
- **Before release:** Google Play reviews apps that read Health Connect data and needs a privacy policy; the permission screen's "privacy policy" link currently opens the app.

### 17. Tracker tab (now includes the trend charts) ✅ (2026-11-02)
- **Goal:** history of meals and weight, plus the trends that Insights was going to show.
- **Built** (`lib/features/tracker/`):
  - **Week / Month** switch (last 7 or 30 days, ending today).
  - **Summary tiles:** day streak (days in a row with food logged; today doesn't break it until it's over), average kcal on logged days, and days on target (within ±10 % of the calorie target).
  - **Weight:** current weight, change in the period, a trend line, and **+ Log** for today's weight (kg or lb, as chosen in onboarding). The newest weigh-in becomes the profile weight, so the targets are recalculated (unless customized on Account). The onboarding weight is the first point. Stored as `weight_log`.
  - **Calories:** a bar per day against a dashed target line, coloured on target / under / over.
  - **Macros:** average protein, carbs and fat per logged day against the targets.
  - **Steps:** a bar per day, with the average and total.
  - **History:** each logged day with kcal / target and macros; tap a day to open it on Home.
- **Charts** are simple custom widgets (`BarChart`, `LineChart`), so no chart package was added.

### 18. Notifications and reminders ✅ (2026-11-02)
- **Goal:** make the bell on Home do something, and remind users to log meals.
- **Built** (`lib/features/reminders/`, `flutter_local_notifications` + `timezone` + `flutter_timezone`):
  - **The Home bell** opens **Reminders** (`/reminders`): a "Today" list (logged ✓ / reminder at… / not logged yet, with **Log now**) and the settings.
  - **Breakfast** (8:00 AM), **lunch** (1:00 PM) and **dinner** reminders, each with an on/off switch and a time. The dinner time is the profile's dinner time (changing it here changes the profile, and the other way round). All start off; turning one on asks for notification permission.
  - **Smart skip:** each reminder is scheduled one day at a time for the next 7 days, so today's is cancelled as soon as that meal is logged. The schedule is refreshed at start, when food is logged, and when settings, the dinner time or the language change.
  - **Red dot** on the bell only when a turned-on reminder's time has passed today and that meal isn't logged.
  - **Tapping a notification** opens Add Food for that meal.
  - Inexact scheduling (no "alarms & reminders" permission needed; a reminder may arrive a few minutes late). Android: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, the plugin's receivers, and core library desugaring. Settings stay on the phone (`reminders`).
- **Checked:** tests (provider and screens). Not yet checked: a real notification arriving on a phone.

### 19. Account management ✅ (2026-11-02)
- **Goal:** edit the profile and manage data.
- **Built:**
  - **Profile card** at the top of the Account tab (name, age, height, weight, goal, activity) with **Edit**.
  - **Edit profile** (`/edit-profile`): name, units (kg · cm / lb · ft), height (cm, or ft + in; 100–250 cm), birthday (age 13–100), gender, weight goal, focus goals, activity level, diet, dinner time. Weight is shown read-only; it's logged on Tracker (17). **Save** recalculates the targets unless they were set by hand, and is disabled for an empty name or impossible height.
  - **Reset all data** at the bottom of Account, behind a confirmation: deletes the profile, meals, weight and activity and starts setup again. While signed in it also deletes the account's copy (you stay signed in). Log out is part of feature 15.

### 22. Polish ✅ (2026-11-02)
- **Meal illustrations:** flat vector drawings made in code (`MealIllustration`, `lib/shared/widgets/meal_illustration.dart`): toast and egg (breakfast), rice bowl (lunch), salad plate (dinner), apple and cookie (snacks), with dark-mode backgrounds. Used on Home, the meal sheet, the meal picker and Reminders; the meal emoji are gone.
- **Dark mode:** Account → **Appearance**: System / Light / Dark (`theme_mode`, on this phone).
  - `AppColors` now has a light and a dark palette; `CalAiApp` picks one and rebuilds every screen when the mode or the phone's setting changes.
  - New colours: `onPrimary` (always-dark text on the green), `accent` (a darker green for text on white, readable in light mode).
  - There were no dark designs, so the dark palette is ours; adjust `AppColors` if designs arrive.
- **Bangla translation:** English and বাংলা (Flutter gen-l10n).
  - The text lives in `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb` (324 strings then; 590 after feature 23's exercise texts), and the code reads it through `l10n`.
  - The app follows the phone's language; Account → **Language** (System / English / বাংলা, saved as `language`) can override it.
  - Dates use the language's own format, with Western digits. Reminder texts follow the language, and the AI is asked to name foods in Bangla.
  - Not translated: brand names, the AI instructions, and internal error messages.
- **Accessibility:**
  - Flutter's guideline checks pass on 8 screens in light, dark and Bangla: tap targets of at least 48 px, labels on everything tappable, and text contrast (`test/accessibility_test.dart`).
  - What got fixed: the bell, the + buttons, the date button and onboarding's back button were made 48 px. The selected-tab and green text now use the readable green. Labels were added to the reminder switches. Header text stays dark on the green header.
  - **Text size:** follows the phone up to 130% (`AppConstants.maxTextScale`); every main screen is checked at that size in English and Bangla.

### 23. AI exercise and workout planner 🟡 in progress (planned 2026-11-12)
- **Goal:** an Exercise tab with a personalised plan. The user picks **Home** or **Gym** once (plus optional extras: fitness level, minutes per session, home equipment, limitations). Gemini builds a **weekly rotating plan**, choosing only from a curated catalog of ~32 exercises. Each exercise has a **code-drawn animated demo**, step-by-step instructions, and a set-by-set workout mode with a rest timer.
- **Calories:** estimates only, net MET method ((MET − 1) × kg × active hours), shown as "≈ N kcal (estimate)", with no fat-loss claims. Finished workouts are added to **Activity** on Home. A workout that overlaps a Health workout in time is skipped, so Health's measured number counts instead.
- **Data:** `exercise_settings`, `workout_plan` and `workout_sessions` (one Firestore doc per session) are synced; the rule-based planner is used when AI is unavailable.
- **Changes to earlier decisions:** the bottom bar (decision 4, feature 11); Health workouts will also store start/end times (feature 16); the focus goals now shape the workout plan.
- **Phases** (each tested, then reviewed by you):
  1. ✅ **Navigation (2026-11-12):** Exercise tab (`/exercise`, placeholder screen) between the camera and Account; the camera button moved from a raised floating button into the bar (52 px). The extra bottom padding that made room for the raised button was removed from Home, Tracker and Account. `EmptyState` text now uses the readable grey (it failed the contrast check). Tests: tab order, camera inside the bar, camera from the Exercise tab, Exercise screen accessibility (light, dark, Bangla).
  2. ✅ **Domain (2026-11-12):** in `lib/features/exercise/data/`:
     - **Models:** `ExerciseSettings` (Home/Gym, level, minutes, home equipment, limitations; level defaults from the activity level, 2–5 sessions a week from it too), `Exercise`, `WorkoutPlan` / `PlannedSession` / `PlannedExercise`, `WorkoutRecord` / `ExerciseRecord` (status from sets done).
     - **Catalog** (`catalog/exercise_catalog.dart`): 36 exercises: 19 bodyweight (home, many also gym), 7 with dumbbells or bands, 10 gym machines. Each has places, equipment, movement type, muscles, MET, seconds per rep, default rest, and the limitations it's left out for. `allowedFor(settings)` filters them. "March in place" was added (not in the original list) because with all four limitations ticked Home had no cardio and only 4 exercises.
     - **Texts:** name, starting position, 3 steps, form tip and benefit for every exercise, plus 12 muscle names, in English and Bangla (264 new strings each; `ExerciseTexts`).
     - **Estimates** (`exercise_estimate.dart`, named `exercise_calories.dart` in the plan): net kcal = (MET − 1) × kg × active hours; planned time = sets + rests; shown kcal rounded (whole below 10, then to 5).
     - **Storage:** `exercise_settings`, `workout_plan`, `workout_sessions` with three repositories (`data/repositories/`). Not synced yet (phase 7).
     - Tests: 31 new (catalog, estimates, models, repositories).
  3. ✅ **AI plan service (2026-11-12):**
     - `WorkoutPlanService` interface (`lib/core/services/workout_plan_service.dart`) with `WorkoutPlanException` (network / invalid response / unknown). Screens will only use this interface.
     - `WorkoutPlanRequest` (`features/exercise/data/`): profile + settings → allowed exercises, sessions per week, "builds muscle" (gain goal or Gain muscle focus), and `inputsKey`, a fingerprint saved with the plan to notice later changes (weight rounded to whole kg).
     - `FirebaseWorkoutPlanService`: Gemini (`AppConstants.workoutPlanModel`, `gemini-3.5-flash-lite`, temperature 0.3, 60 s timeout). The prompt lists the user's details and the allowed exercises; the reply schema only accepts their ids (`Schema.enumString`). Texts are asked for in Bangla when the app is in Bangla. The instructions rule out medical advice and fat-loss claims.
     - `WorkoutPlanValidator`: drops unknown, not allowed and repeated exercises; keeps sets 1–5, reps 4–25, time 15–120 s (cardio machines up to 15 min), rest 20–150 s; 3–8 exercises per session, cut from the end while over the chosen minutes by more than 25 %; no more sessions than workout days; shortens long texts.
     - `RuleBasedWorkoutPlanService`: works without AI. 2–3 days a week are full body, 4–5 alternate upper and lower body. 4–7 exercises depending on minutes. Sets by level, reps by goal, rest adjusted by goal. It is the default in `CalAiApp` (tests); `main.dart` passes the Gemini service. Falling back to it when AI fails is phase 4.
     - The network-error check is shared with the food AI (`gemini_errors.dart`). The plan's "move `GeminiCall` to `gemini_call.dart`" wasn't needed: the plan service has its own call type with a schema.
     - **Not yet done:** a real Gemini call on a device; that is checked in phase 4, once the setup screen exists.
     - Tests: 27 new (validator, rule-based planner across every setup, Gemini service with a fake model, plan fingerprint).
  4. ✅ **Setup and dashboard (2026-11-12):**
     - `ExerciseProvider`: saves the setup and makes the plan. If the AI fails, the built-in rules make it instead and the dashboard says so, with **Try AI again**. It notices when the profile or setup changed since the plan was made ("Update plan"). Today's session is the one after the last finished workout of this plan (or today's, once started). Card status and progress come from today's workout record. It reloads after sign-in, log out and Reset all data.
     - **First visit:** the Exercise tab shows the Home / Gym choice with **Customise (optional)** folded away: fitness level (defaults from the activity level), minutes (15–60), home equipment (Home only) and limitations; plus the safety note. **Create my plan** shows "Creating your plan…".
     - **Dashboard:** offline or outdated notice, the plan summary, session chips (today's marked), a progress card (ring done/total; exercises, done, left, ≈ minutes, ≈ kcal), the session focus, a **two-column grid** of exercise cards (picture, name, sets × reps or time, ≈ kcal, Not started / In progress / Done with their own colours; completed cards turn green) and the calorie disclaimer. Any number of exercises; rows take the taller card's height.
     - **App bar:** Make a new plan (asks first) and **Workout setup** (`/exercise-setup`, prefilled; **Update my plan** saves and makes a new plan).
     - Card pictures are icons for the movement type until the demos (phase 5). Tapping a card does nothing yet (details are phase 5).
     - Strings: 53 new (English and Bangla).
     - Tests: 30 new (provider, widgets, accessibility in light/dark/Bangla, large text ×1.3 and ×2).
     - **Not yet checked:** a real Gemini plan on a device, and how it looks on a phone. The emulator available today (`nx-api33`) is locked with a screen lock, so the app can't start on it.
  5. ⬜ Animated demos and the exercise details screen.
  6. ⬜ Workout mode: sets, rest timer, completion, history.
  7. ⬜ Calories into Home and Tracker (no Health double-counting), sync.
  8. ⬜ Polish: accessibility, dark mode, Bangla, emulator run-through.

---

## Suggested order
1. **Follow-ups:** commit, real-phone test.
2. **Camera bar and chooser (11 ✅, 12 ✅).**
3. **AI screens (13 ✅, 14 ✅).** Both flows use the real Gemini AI through Firebase AI Logic.
4. **Tracker with charts (17 ✅).** Weight logging now updates the profile weight.
5. **Firebase (15) — done except one Console step:** Firestore is in Mumbai with rules, and sign-in/sync work on the local emulators. Left: turn on Email/Password (you), try it on the real project, run on iOS.
6. **Health Connect / HealthKit (16 ✅).** Check with real data and on iOS.
7. **Account management (19 ✅).**
8. **Notifications (18 ✅), polish (22 ✅).**

**Feature 23 (exercise planner) is in progress** (phases 1–4 of 8 done); the other planned features are complete. Also left is checking and release work: turn on Email/Password and try sign-in on the real project, run on iOS and a real phone (photo AI, Health data, notifications), then the release checklist under feature 15 (real app ID, Play signing SHA-256, App Attest, privacy policy for Health Connect).

**Dropped (2026-11-02):** food database and barcode (was 20) and the Articles tab (was 21); the Articles tab was removed from the bottom bar.

## Open questions
- **Existing Add Food form:** kept as "Enter numbers myself" under Add manually.
