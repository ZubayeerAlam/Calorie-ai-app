import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Onboarding walks every step and lands on the dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.init();
    await tester.pumpWidget(CalAiApp(storage: storage));
    await tester.pumpAndSettle();

    Future<void> next() async {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }

    expect(find.text('1 / 10'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Sam');
    await tester.pump();
    await next();

    await tester.tap(find.text('Female'));
    await tester.pump();
    await next();
    await next(); // birthday (default is valid)
    expect(find.text('How tall are you?'), findsOneWidget);
    await next();

    expect(find.text('70.0'), findsOneWidget);
    await tester.tap(find.text('lb'));
    await tester.pump();
    expect(find.text('154.3'), findsOneWidget);
    await next();

    await tester.tap(find.text('Lose weight'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);
    await next();

    await tester.tap(find.text('Sedentary'));
    await tester.pump();
    await next();
    await tester.tap(find.text('Classic'));
    await tester.pump();
    await next();

    expect(find.text('9 / 10'), findsOneWidget);
    expect(find.text('PM'), findsOneWidget);

    // The loader fills part-way, X backs out, then it runs to the plan.
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.textContaining('Personalizing your'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
    expect(find.text('100%'), findsNothing);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('9 / 10'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    // Step frame by frame (pumpAndSettle doesn't wait for the 100% hold timer).
    var sawFull = false;
    for (var i = 0; i < 60 && find.text('Finish').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      sawFull |= find.text('100%').evaluate().isNotEmpty;
    }
    expect(sawFull, isTrue);
    await tester.pumpAndSettle();

    expect(find.text('Your plan is ready'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);

    // The finished profile is saved for the next launch.
    expect(storage.getJson(StorageKeys.userProfile)?['name'], 'Sam');

    // Relaunch: a fresh app on the same storage opens straight to Home.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(CalAiApp(storage: storage));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text("What's your name?"), findsNothing);
  });
}
