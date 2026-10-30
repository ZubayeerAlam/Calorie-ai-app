# Cal AI — Build Status

_Last updated: 2026-10-30 · 67 tests passing · `flutter analyze`: no issues_

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
                         # ImagePickerService, StepCounterService
    theme/               # AppColors, AppTheme
    utils/               # CalorieCalculator, AppDates
  features/
    onboarding/          # provider, host screen, step pages, widgets
    dashboard/           # Home screen and its widgets (one per file)
    food_log/            # FoodEntry model, repository, provider, Add Food
    food_scan/           # Scan screen and provider (camera / gallery)
    activity/            # activity kcal + daily steps (repositories, provider)
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
| `/tracker`, `/articles` | Placeholder tabs that say "coming soon" |
| `/account` | Account tab (profile and goals) |
| `/add-food?meal=lunch&imagePath=…` | Add Food, shown on top of the tabs |
| `/scan` | Scan a photo. With `?returnPhoto=true` (opened from Add Food) it sends the photo back; otherwise (opened from the camera chooser) it sends the photo for analysis |
| `/analyze-food?imagePath=…` | AI analysis of the photo, then review, edit and save |

- **Tabs:** they use `StatefulShellRoute`, so each tab remembers its own screen.
- **Bottom bar:** four tabs (Home, Tracker, Articles, Account) with a raised camera button in the middle. The camera button is an action, not a tab. It opens a chooser sheet with two options: **Scan with camera** (Scan screen, then AI analysis and review) and **Add manually** (the Add Food form).
- **Redirect:** with no saved profile, every route goes to `/onboarding`. After onboarding, `/onboarding` sends you to `/`.

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

### AI photo analysis (demo for now)
- **Flow:** photo → "Analyzing your meal…" → a list of foods with portion, calories and macros → edit any value or remove items → pick the meal (suggested from the time of day) → **Add to <meal>**. Each item is saved as its own entry with the photo, marked "(AI estimate)".
- **Errors:** "No food found" offers another photo or manual entry; connection and other errors offer "Try again" or manual entry.
- **Demo service:** real AI needs Firebase, so the app uses `DemoFoodAnalysisService`. It doesn't look at the photo; it returns sample meals, and the screen shows a "Demo result" notice. Swapping in the real service is one class (see plan.md, feature 13).

### Steps
- **Source:** the `pedometer` package reports steps since the phone was last switched on. The app saves a starting count each day and uses "now − start".
  - On a new day, counting starts again from 0.
  - If the phone restarts, today's count carries on.
- **Permissions:**
  - **Android:** `ACTIVITY_RECOGNITION`, asked for when the app runs.
  - **iOS:** the system Motion prompt, using `NSMotionUsageDescription`.
- **Walking line:** shows "x steps", or "Allow step access" / "No step sensor".

### Persistence
- **What's saved:** the profile, goals, food log, activity kcal and daily steps are all saved locally.
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
| `step_baseline` | `{ day, base, last }` used to turn the pedometer total into daily steps |

## 7. Design system
- **Colours:** `AppColors` holds the brand green, text greys, card and background colours, and ring colours.
- **Theme:** `AppTheme` uses the Outfit font with a green theme. The app is fixed to **light mode** (`themeMode: ThemeMode.light`).
- **Shared widgets:** `ProgressRing`, `AddCircleButton`, `EmptyState`, `ComingSoonScreen`.

## 8. Tests (67 passing)

| File | Covers |
|---|---|
| `test/calorie_calculator_test.dart` | BMR, TDEE, goal adjustment, minimum, macros, breakdown, walking kcal, macro estimate |
| `test/profile_provider_test.dart` | Custom goals survive a relaunch; reset restores the recommended targets |
| `test/step_log_repository_test.dart` | Daily steps, new day, phone restart |
| `test/widget_test.dart` | Home, the bottom bar (4 tabs + camera button), the camera chooser and both of its options, the AI photo flow (review, edit, save, errors, demo notice), Add Food per meal, activity, date switching, Scan, onboarding redirect, persistence, steps, macro estimates, the empty hint |
| `test/onboarding_test.dart` | Full onboarding flow, the loader (✕ and completion), the profile being saved, relaunch skipping onboarding |
| `test/user_profile_test.dart` | Dinner time and focus goals saved and restored, defaults for older profiles, the "8:30 PM" label |
| `test/onboarding_provider_test.dart` | Goal-step rules: at least one goal, weight goals exclude each other, focus goals combine |
| `test/food_analysis_test.dart` | Parsing the AI reply (valid, not food, malformed), the demo service |
| `test/food_analysis_controller_test.dart` | Analysis states, retry, editing/removing items, meal suggestion, saved entries, closing mid-analysis |
| `test/fake_step_counter.dart`, `test/fake_image_picker.dart`, `test/fake_food_analysis_service.dart` | Fake step source, camera/gallery and AI used by the tests |

Run them with:

```bash
flutter test
```

## 9. Known limitations / not built yet
- **AI analysis:** the photo flow is built but uses a demo service until Firebase is set up. Results are sample foods, clearly labelled.
- **Steps:** counting starts the first time the app is opened each day. There is no Apple Health or Health Connect integration.
- **Tabs:** Tracker and Articles are placeholders.
- **Header:** the notification bell does nothing yet.
- **Data:** there is no logout or "reset data" option.
- **Focus goals:** Gain muscle, Boost energy and Improve nutrition are saved and shown on Home, but don't change the calorie target yet. The diet type also doesn't affect macros.
- **Visuals:** meal pictures are emoji placeholders, and dark mode is off.
- **Backend:** there is no backend or account sync; data lives only on the device.
- **Testing:** checked with automated tests and test renders, but not yet on a physical device.

## 10. Next steps

The full roadmap, with each feature's tasks, is in [plan.md](plan.md). The planned direction:

- **Camera options:** the photo option runs the AI review flow on a demo service; real AI comes with Firebase. The manual option (AI from typed details, feature 14) is next.
- **Camera button:** opens a chooser with two options: scan a food photo (AI analyses it) or add manually (AI generates the nutrition data from your details).
- **Firebase:** you will set it up yourself when we reach that step; sign-in, sync and the AI calls depend on it.
- **Before that:** commit the untracked files (the latest commit imports files that aren't in git yet, so a fresh clone won't build) and test on a real phone.
