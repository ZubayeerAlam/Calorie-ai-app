import 'package:cal_ai_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Onboarding walks every step and lands on the dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CalAiApp());
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
    await next();

    expect(find.text('Your plan is ready'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });
}
