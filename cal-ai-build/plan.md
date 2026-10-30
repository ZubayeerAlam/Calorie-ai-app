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
4. **The bottom bar becomes:** Home · Tracker · 📷 Camera (centre action, not a tab) · Articles · Account.

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
- [ ] **Decide what the focus goals do.** For now they are saved and shown only. Ideas: Gain muscle could raise the protein share, Boost energy could add reminders, Improve nutrition could add food tips. Say which, if any, you want.

---

## ⬜ Future features

### 11. Bottom bar: remove Insights, add the camera button ✅
- **Goal:** the new bar from decision 4. No Firebase needed.
- **Done:** Insights is gone (route, tab and placeholder). The bar has Home, Tracker, Articles and Account, with a raised green camera button in the middle. The button is an action, so it doesn't change the page behind it.
- The camera button opens the two-option chooser (feature 12).
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

### 13. AI analysis of a food photo (camera option) 🟡 built, real AI pending Firebase
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
- **Not real AI yet:** the app uses `DemoFoodAnalysisService`, which does **not** look at the photo. It returns one of three sample meals after 1.5 s, and the review screen shows a yellow "Demo result" notice so samples are never mistaken for a real analysis.
- **To finish after Firebase (feature 15):** write one class that implements `FoodAnalysisService` (send the photo through Firebase to the AI, parse the reply with `FoodAnalysis.fromJson`, map errors to `FoodAnalysisFailure`), then pass it to `CalAiApp(foodAnalysis: …)` in `main.dart`. Nothing else changes.

### 14. AI from manually entered details (manual option) ⬜
- **Goal:** the user types the food details and the AI generates the nutrition data.
- **Flow:**
  1. User writes what they ate, e.g. "2 scrambled eggs, 1 slice toast with butter, black coffee".
  2. Optional extra details: portion size, cooking method, brand, ingredients.
  3. The AI returns calories and macros per item.
  4. Same review-and-edit screen as feature 13, then save.
- **Tasks:**
  - Manual-entry screen (description field and optional detail fields).
  - Reuse `FoodAnalysisService` with a text-based method, plus the shared review screen from feature 13.
  - Keep the current Add Food form as a "Enter numbers myself" option for people who already know the values, with no AI.
- **Needs Firebase** (feature 15) for the real AI call.

### 15. Firebase — you implement this ⬜
- **Who:** you set up Firebase yourself when we reach this step. I won't add Firebase packages or config before then.
- **What the app needs from it** (so you know what to set up):
  - **Authentication:** sign-in, so each user has their own data.
  - **Cloud Firestore:** profile, goals, food log, activity and steps, synced across devices.
  - **Cloud Storage:** food photos.
  - **Server-side AI:** the AI call for features 13 and 14 goes through Firebase (for example Firebase AI Logic or a Cloud Function), so the AI key is never inside the app.
- **What we prepare beforehand:**
  - Every data class is already behind a repository (`FoodLogRepository`, `ActivityLogRepository`, `StepLogRepository`, `ProfileProvider`), so storage can be swapped without changing screens.
  - The `FoodAnalysisService` interface (built in feature 13), so the AI backend is one class to replace.
- **When you're done:** tell me, and we will:
  - connect the repositories to Firestore (local cache + remote);
  - move existing on-device data to the account;
  - add sign-in screens and the logout option;
  - connect `FoodAnalysisService` to the real AI call.

### 16. Apple Health / Health Connect ⬜
- **Goal:** accurate steps for the whole day, and imported workouts for the Activity number.
- **Tasks:**
  - Add the `health` package.
  - Set up the iOS HealthKit capability and Android Health Connect permissions.
  - Use it as the step source, with `pedometer` as a fallback.
- **Fixes:** today, steps are only counted from the first time the app is opened each day.

### 17. Tracker tab (now includes the trend charts) ⬜
- **Goal:** history of meals and weight, plus the trends that Insights was going to show.
- **Tasks:**
  - A weight log (add today's weight, see the list).
  - Daily history with totals.
  - Update the profile weight, which recalculates the targets.
  - Weekly and monthly charts inside Tracker: calories vs target, macro breakdown, steps, weight trend, streaks.

### 18. Notifications and reminders ⬜
- **Goal:** make the bell on Home do something, and remind users to log meals.
- **Tasks:**
  - Local notifications, including a dinner reminder at the saved dinner time.
  - Reminders for breakfast and lunch.
  - A notifications list behind the bell.

### 19. Account management ⬜
- **Goal:** edit the profile and manage data.
- **Tasks:**
  - Edit name, weight, height, goal and activity (targets recalculate).
  - Unit preference.
  - "Reset all data" now; log out after Firebase sign-in (feature 15).

### 20. Food database and barcode ⬜
- **Goal:** faster logging.
- **Tasks:**
  - Search foods (e.g. Open Food Facts).
  - Barcode scanning.
  - Recent and favourite foods.
  - Quick re-log.

### 21. Articles tab ⬜
- **Goal:** nutrition tips and articles (start with built-in content, a remote feed later).

### 22. Polish ⬜
- Real meal illustrations to replace the emoji (`MealTile` already accepts an asset path).
- Dark mode, once there are dark designs.
- Translations into other languages.
- Accessibility checks.

---

## Suggested order
1. **Follow-ups:** commit, real-phone test, save the dinner time.
2. **Camera bar and chooser (11, 12).** No Firebase needed.
3. **AI screens with a fake service (13 ✅, 14).** The photo flow is built on a demo service; the manual flow (14) is next.
4. **Account management (19).** Small, and makes weight changes possible.
5. **Tracker with charts (17).**
6. **Firebase (15), done by you.** Then we connect sign-in, sync and the real AI calls.
7. **Health Connect / HealthKit (16).**
8. **Notifications (18), food database (20), Articles (21), polish (22).**

## Open questions
- **Insights charts:** is it OK for them to live inside Tracker, as planned in feature 17?
- **AI provider:** which model or service will the Firebase side use (e.g. Gemini through Firebase AI Logic)? This only matters when we reach feature 15.
- **Existing Add Food form:** keep it as the "Enter numbers myself" option under Manual (planned), or remove it?
