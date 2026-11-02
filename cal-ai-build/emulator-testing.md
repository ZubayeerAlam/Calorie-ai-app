# Testing sign-in and sync on the Firebase emulators

Sign-in and sync can be tried without touching the real Firebase project.

1. Start the local Auth and Firestore emulators (needs Java; config is in `firebase.json`):
   ```bash
   firebase emulators:start --only auth,firestore --project cal-ai-app-c32f8
   ```
2. Run the app against them (debug builds only; see `main.dart`):
   ```bash
   flutter run -d emulator-5554 --dart-define=USE_FIREBASE_EMULATORS=true
   ```
   The Android emulator reaches the computer at `10.0.2.2`; plain http to it is allowed in debug builds only (`android/app/src/debug/res/xml/network_security_config.xml`).
3. Create an account in the app. Emulator accounts and data disappear when the emulators stop.

Test account used on the emulators (not a real account):

| Email | Password |
|---|---|
| `tester@cal-ai.test` | `emulator-only-1` |

Look at what was synced (the `owner` token skips the security rules):
```bash
curl -s -H "Authorization: Bearer owner" "http://127.0.0.1:8080/v1/projects/cal-ai-app-c32f8/databases/(default)/documents/users"
```
