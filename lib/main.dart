import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/auth_service.dart';
import 'core/services/cloud_store.dart';
import 'core/services/firebase_food_analysis_service.dart';
import 'core/services/health_service.dart';
import 'core/services/local_storage_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // App Check proves requests come from this app, so only it can use the AI.
  // Debug builds use the debug provider: the device prints a debug token to
  // the log, which is registered once in Firebase Console → App Check →
  // Manage debug tokens. Release builds use Play Integrity / App Attest.
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleAppAttestWithDeviceCheckFallbackProvider(),
  );
  final storage = await LocalStorageService.init();
  // The real services; the app's defaults (used by tests) are the demo AI
  // and no Health or accounts.
  runApp(
    CalAiApp(
      storage: storage,
      foodAnalysis: FirebaseFoodAnalysisService(),
      health: HealthPluginService(),
      auth: FirebaseAuthService(),
      cloudStore: FirestoreCloudStore(),
    ),
  );
}
