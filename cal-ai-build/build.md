# Cal AI — Build Status

_Last updated: 2026-11-02 · 129 tests passing · `flutter analyze`: no issues_

What the app is **right now**. For what's done and what's next, see the roadmap in [plan.md](plan.md).

## 1. Overview

Cal AI is a Flutter calorie and macro tracker.

1. A new user completes a **10-step onboarding**.
2. A **"Personalizing your experience"** loader runs.
3. The user sees their **calculated plan**.
4. They land on the **Home dashboard**, where they log meals, activity and steps.

All data is stored **on the device** with `shared_preferences`. There is no backend yet.

The UI follows the provided "Nutrio" mockups: brand green `#A3CE50`, the **Outfit** font, and light mode only.

## 2. Tech stack

| Purpose | Package |
|---|---|
| Framework | Flutter 3.47, Dart `^3.13` |
| State | `provider` |
| Navigation | `go_router` |
| Local storage | `shared_preferences` |
| Step counting | `pedometer` |
| Photos and permissions | `image_picker`, `permission_handler` |
| Firebase | `firebase_core`, `firebase_ai` (Gemini through AI Logic), `firebase_app_check`, `firebase_auth` (optional sign-in), `cloud_firestore` (cloud backup and sync) |
| Health | `health` (Apple Health / Health Connect: steps and workouts) |
| Font | Outfit (bundled in `assets/fonts/`) |

## 3. Architecture

The code is organised by feature:

```
lib/
  main.dart              # sets up storage, then runApp(CalAiApp)
  app.dart               # registers all providers and builds MaterialApp.router
  core/
    constants/           # AppConstants (app name, defaults)
    routes/              # AppRoutes (paths), app_router.dart (GoRouter)
    services/            # LocalStorageService, PermissionService,
                         # ImagePickerService, StepCounterService, HealthService,
                         # FoodAnalysisService, AuthService, CloudStore
    theme/               # AppColors, AppTheme
    utils/               # CalorieCalculator, AppDates, AppNumbers
  features/
    onboarding/          # provider, host screen, step pages, widgets
    dashboard/           # Home screen and its widgets (one per file)
    food_log/            # FoodEntry model, repository, provider, Add Food
    food_scan/           # Scan screen and provider (camera / gallery)
    activity/            # activity kcal, daily steps, Health import (repositories, provider, Health card)
    tracker/             # Tracker tab: weight log, stats, charts, history
    account/             # sign-in screen, AccountProvider, SyncService, Account card
    profile/             # UserProfile/UserGoals models, provider, Account screen
    home/                # tab shell and the custom bottom navigation bar
  shared/widgets/        # ProgressRing, AddCircleButton, EmptyState, ComingSoonScreen
```

How it fits together:

- **One widget per file.** Each UI component is its own class in its own file.
- **Services wrap plugins.** Features never call plugins directly; they go through the services in `core/services/`. This lets tests swap in fakes, for example `test/fake_step_counter.dart`.
- **Data flow.** Data lives in a **repository**, which reads and writes local storage. A **provider** (a `ChangeNotifier`) holds the screen state. **Widgets** read that state with `context.watch` and rebuild when it changes.

## 4. Navigation

Routing uses `go_router` and is set up in `lib/core/routes/app_router.dart`.

| Route | Screen |
|---|---|
| `/onboarding` | Onboarding flow |
| `/` | Home (dashboard) tab |
| `/tracker` | Tracker tab: week/month stats, weight, calories, macros, steps, history |
| `/articles` | Placeholder tab that says "coming soon" |
| `/account` | Account tab: profile (Edit), account (sign in / log out), Health, goals, Reset all data |
| `/sign-in` | Sign in or create an account (optional; also reachable from onboarding) |
| `/edit-profile` | Edit profile: name, units, height, birthday, gender, goals, activity, diet, dinner time |
| `/add-food?meal=lunch&imagePath=…` | Add Food, shown on top of the tabs |
| `/scan` | Scan a photo. With `?returnPhoto=true` (opened from Add Food) it sends the photo back; otherwise (opened from the camera chooser) it sends the photo for analysis |
| `/add-manually` | Describe a meal in words (plus optional details) for AI analysis; "Enter numbers myself" opens Add Food |
| `/analyze-food?imagePath=…` | AI analysis of a photo (or of a description passed along with the navigation), then review, edit and save |

- **Tabs:** they use `StatefulShellRoute`, so each tab remembers its own screen.
- **Bottom bar:** four tabs (Home, Tracker, Articles, Account) with a raised camera button in the middle. The camera button is an action, not a tab. It opens a chooser sheet with two options: **Scan with camera** (Scan screen, then AI analysis and review) and **Add manually** (describe the meal, then AI analysis and review).
- **Redirect:** with no saved profile, every route except `/sign-in` goes to `/onboarding`. After onboarding, `/onboarding` sends you to `/`. The router re-checks only when onboarding status changes (finishing onboarding, restoring an account, logging out).

## 5. Features built

### Onboarding (10 steps)
- **Steps:**
  1. Name
  2. Gender
  3. Birthday
  4. Height (custom scroll wheel, cm or ft/in)
  5. Weight (drag ruler, kg or lb)
  6. Goal (multi-select: one weight goal plus any focus goals)
  7. Activity level (4 levels)
  8. Diet
  9. Dinner time (looping wheel with AM/PM)
  10. Plan
- **Layout:** back arrow, progress bar and "n / 10" at the top; Continue (or Finish) at the bottom. It is disabled until the step is complete.
- **Personalizing loader:** a full-screen "Personalizing your Cal AI experience…" page.
  - A ring fills from 0% to 100% over 4 seconds.
  - ✕ goes back to the previous step.
  - When it finishes, the **plan page** shows daily calories, macro grams and the expected kg per week.

### Calorie engine (`lib/core/utils/calorie_calculator.dart`)
- **BMR (Mifflin-St Jeor):**
  - Men: `10·kg + 6.25·cm − 5·age + 5`
  - Women: `10·kg + 6.25·cm − 5·age − 161`
  - "Other" gender: the midpoint between the two.
- **TDEE:** BMR × 1.2 / 1.375 / 1.55 / 1.725, depending on activity level.
- **Target:** TDEE − 500 (lose), + 0 (maintain) or + 500 (gain). It never goes below **1200 kcal**.
- **Macros:** 50% carbs, 30% protein, 20% fat of the target, at 4 / 4 / 9 kcal per gram.
- **Helpers:**
  - `breakdown()`: every step of the calculation, used by the "Your calorie plan" card.
  - `estimateMacroGrams()`: fills in macros from calories.
  - `walkingKcal()`: 0.0005 × kg × steps.
  - `weeklyChangeKg()`: expected kg gained or lost per week.

### Goal sync
- **On launch:** calorie and macro targets are recalculated from the saved profile.
- **Hand edits:** moving the calorie slider on Account saves the flag `goals_customized`, and your values are kept from then on.
- **Reset:** "Reset to recommended" clears the flag. The slider also re-splits macros 50/30/20.

### Home dashboard
- **Header:**
  - Avatar with your initials.
  - "Good morning / afternoon / evening, Name".
  - Your goal and daily kcal.
  - Notification bell.
- **Date selector:** ‹ › move one day, 📅 opens a picker. Future days are not allowed.
- **Calories row:** Eaten | a ring showing **kcal left** | Burned. kcal left is target − eaten + burned; the ring turns red when you go over.
- **Eaten section:** rings for carbs, protein and fat (grams eaten out of the target).
- **Burned section:**
  - **Walking:** from steps, with "x steps" underneath.
  - **Activity:** entered by hand with the ＋ button (bottom sheet).
- **Empty-log hint:** shown while nothing is logged for the selected day.
- **Meals:**
  - Breakfast, Lunch, Dinner and Snacks, with targets split 30/30/30/10.
  - ＋ opens Add Food with that meal already chosen.
  - Tapping a meal lists its entries, which you can delete.
- **Profile card:** goal, kg per week, weight, height, age, and BMI with its category. Uses your chosen metric or imperial units.
- **"Your calorie plan" card:** BMR → activity → goal adjustment → recommended target, plus your custom target if you set one, and the macro split.

### Add Food and Scan
- **Add Food:**
  - The meal is already chosen when opened from a meal's ＋.
  - Food is logged on the day being viewed on Home.
  - If protein, carbs and fat are all left blank, they are **estimated from calories** and the entry is marked "(est.)".
- **Scan:** the Scan screen opens the camera or gallery. From Add Food's "Scan a photo" button the chosen photo goes back into that form; from the camera button's chooser it goes to the AI analysis.

### AI analysis: photo and manual (real Gemini AI)
- **Manual flow:** describe the meal ("2 eggs, toast and coffee") plus optional portion, cooking method, brand and ingredients → **Analyze with AI** → the same review as photos, with "You described" in place of the photo. Back from the review keeps your text; saving closes both screens. "Enter numbers myself" opens the classic form.
- **Photo flow:** photo → "Analyzing your meal…" → a list of foods with portion, calories and macros → edit any value or remove items → pick the meal (suggested from the time of day) → **Add to <meal>**. Each item is saved as its own entry with the photo, marked "(AI estimate)".
- **Errors:** "No food found" offers another photo or manual entry; connection and other errors offer "Try again" or manual entry.
- **Real AI:** `FirebaseFoodAnalysisService` sends the photo (resized to at most 1600 px) or the description to Gemini (`gemini-3.5-flash-lite`) through Firebase AI Logic and gets structured JSON back. No API key is in the app.
- **App Check:** AI Logic only accepts requests from this app. Debug builds use a debug token registered in Firebase; release builds use Play Integrity / App Attest (see plan.md, feature 15).
- **Demo service:** `DemoFoodAnalysisService` (sample results with a "Demo result" notice) is still the default in `CalAiApp`, so tests never call the real AI. `main.dart` passes the real service.

### Tracker
- **Week / Month:** summary tiles (streak, average kcal, days on target), weight with trend line and **+ Log**, calories per day against the target line, average macros, steps per day, and the history of logged days (tap one to open it on Home).
- **Weight:** the newest weigh-in is the profile weight, so logging a weight recalculates the targets (unless customized).

### Accounts and sync (optional)
- **Sign in / create account** with email and password from the Account tab, or from the first onboarding step to restore an account.
- **Sync:** local storage stays the source the app reads; while signed in every change is copied to Firestore (`users/{uid}/…`). Signing in merges this phone's data with the account's. **Log out** clears this phone and returns to onboarding.
- Firestore is in `asia-south1` with per-user rules. Email/Password still needs turning on in the Console (plan.md, feature 15).
- **Local testing:** `flutter run --dart-define=USE_FIREBASE_EMULATORS=true` uses the local Auth and Firestore emulators instead; see [emulator-testing.md](emulator-testing.md).

### Account tab
- **Profile card** with **Edit** → Edit profile; saving recalculates the targets unless they were set by hand. Weight is logged on Tracker.
- **Reset all data** (with a confirmation) deletes everything and starts setup again; while signed in it also clears the account's copy.

### Health (Apple Health / Health Connect)
- **Connect** on the Account tab imports steps and workout calories (last 30 days, then the last 7 days on each start/resume). A day's steps are the higher of the phone sensor and Health; workout kcal is added to Activity on Home.

### Steps
- **Source:** the `pedometer` package reports steps since the phone was last switched on. The app saves a starting count each day and uses "now − start". With Health connected, the higher of this and Health's count is used.
  - On a new day, counting starts again from 0.
  - If the phone restarts, today's count carries on.
- **Permissions:**
  - **Android:** `ACTIVITY_RECOGNITION`, asked for when the app runs.
  - **iOS:** the system Motion prompt, using `NSMotionUsageDescription`.
- **Walking line:** shows "x steps", or "Allow step access" / "No step sensor".

### Persistence
- **What's saved:** the profile, goals, food log, activity kcal, daily steps and the weight log are all saved locally, and copied to Firestore while signed in.
- **Returning users** skip onboarding.
- **Safety:** if saved data can't be read, it is deleted and the app falls back safely (for example, back to onboarding) instead of crashing.

## 6. Local storage keys

| Key | Contents |
|---|---|
| `user_profile` | `UserProfile` JSON, including dinner time and focus goals (its presence means onboarding is done) |
| `user_goals` | `UserGoals` JSON (kcal, protein, carbs, fat) |
| `goals_customized` | `true` once targets were edited by hand on Account |
| `food_entries` | List of `FoodEntry` JSON |
| `activity_kcal` | `{ "YYYY-MM-DD": kcal }` |
| `walking_steps` | `{ "YYYY-MM-DD": steps }` |
| `step_baseline` | `{ day, base, last }` used to turn the pedometer total into daily steps (device only) |
| `weight_log` | `{ "YYYY-MM-DD": kg }`, one weigh-in per day |
| `health_connected` | `true` while Health is connected (device only) |
| `health_steps` | `{ "YYYY-MM-DD": steps }` imported from Health (device only) |
| `health_workout_kcal` | `{ "YYYY-MM-DD": kcal }` workouts imported from Health (device only) |

## 7. Design system
- **Colours:** `AppColors` holds the brand green, text greys, card and background colours, and ring colours.
- **Theme:** `AppTheme` uses the Outfit font with a green theme. The app is fixed to **light mode** (`themeMode: ThemeMode.light`).
- **Shared widgets:** `ProgressRing`, `AddCircleButton`, `EmptyState`, `ComingSoonScreen`.

## 8. Tests (129 passing)

| File | Covers |
|---|---|
| `test/calorie_calculator_test.dart` | BMR, TDEE, goal adjustment, minimum, macros, breakdown, walking kcal, macro estimate |
| `test/profile_provider_test.dart` | Custom goals survive a relaunch; reset restores the recommended targets |
| `test/step_log_repository_test.dart` | Daily steps, new day, phone restart |
| `test/widget_test.dart` | Home, the bottom bar (4 tabs + camera button), the camera chooser and both of its options, the AI photo and manual flows (review, edit, save, errors, Back keeps text, "Enter numbers myself", demo notices), Add Food per meal, activity, date switching, Scan, onboarding redirect, persistence, steps, macro estimates, the empty hint |
| `test/onboarding_test.dart` | Full onboarding flow, the loader (✕ and completion), the profile being saved, relaunch skipping onboarding |
| `test/user_profile_test.dart` | Dinner time and focus goals saved and restored, defaults for older profiles, the "8:30 PM" label |
| `test/onboarding_provider_test.dart` | Goal-step rules: at least one goal, weight goals exclude each other, focus goals combine |
| `test/food_analysis_test.dart` | Parsing the AI reply (valid, not food, malformed), `FoodDescription`, the demo service for photos and text |
| `test/firebase_food_analysis_service_test.dart` | The real service with a fake Gemini: photo bytes and image type, the text prompt, "no food", bad replies, no connection / timeout, other errors |
| `test/food_analysis_controller_test.dart` | Analysis states, retry, editing/removing items, meal suggestion, saved entries, closing mid-analysis, text requests |
| `test/tracker_stats_test.dart` | Days in a period, totals and averages, on target, streak, steps, weights and their change, chart labels |
| `test/weight_log_test.dart` | Starting weight, logging updates the profile and targets, older weigh-ins, removing, custom targets kept |
| `test/health_import_test.dart` | Connect / refuse / disconnect, imported steps and workouts, higher of sensor and Health, later syncs |
| `test/sync_service_test.dart` | Upload to a new account, device-only keys, sign-in merge, copying later changes, disconnect, unreadable cloud |
| `test/account_provider_test.dart` | Sign in, create account, wrong password, unreachable backup, log out, sync at start, Firebase error codes |
| `test/tracker_account_widget_test.dart` | Tracker summary, logging a weight, opening a day; Account sign-up and log out, wrong password, restoring from onboarding; editing the profile (cm and ft/in, validation); Reset all data; Health connect |
| `test/fake_*.dart` | Fake step source, camera/gallery, AI, Health, Auth and Firestore used by the tests |

Run them with:

```bash
flutter test
```

## 9. Known limitations / not built yet
- **AI analysis:** uses the real Gemini AI. The text flow is checked on the Android emulator; a real photo and the iOS simulator are not yet checked. Release builds need the Play Store signing SHA-256 and App Attest registered for App Check.
- **Steps:** without Health connected, counting starts the first time the app is opened each day. Health import is checked up to the permission screen on Android; real data and iOS are not yet checked.
- **Tabs:** Articles is a placeholder.
- **Header:** the notification bell does nothing yet.
- **Focus goals:** Gain muscle, Boost energy and Improve nutrition are saved and shown on Home, but don't change the calorie target yet. The diet type also doesn't affect macros.
- **Visuals:** meal pictures are emoji placeholders, and dark mode is off.
- **Accounts and sync:** checked end to end on the local Firebase emulators, not yet on the real project (Email/Password still needs turning on). Meal photos aren't synced, and an entry deleted on one phone can come back from another.
- **Testing:** checked with automated tests and test renders, but not yet on a physical device.

## 10. Next steps

The full roadmap, with each feature's tasks, is in [plan.md](plan.md). The planned direction:

- **Camera options:** both options (photo and manual) run the AI review flow on the real Gemini AI.
- **Camera button:** opens a chooser with two options: scan a food photo (AI analyses it) or add manually (AI generates the nutrition data from your details).
- **Firebase:** the real AI, sign-in and sync are in the app, and Firestore is set up in Mumbai. Still to do (you): enable Email/Password and run on iOS. See plan.md, feature 15.
- **Before that:** commit the untracked files (the latest commit imports files that aren't in git yet, so a fresh clone won't build) and test on a real phone.
