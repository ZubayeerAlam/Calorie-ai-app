import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard shows calorie summary and empty log', (tester) async {
    await tester.pumpWidget(const CalAiApp(initialRoute: AppRoutes.home));
    await tester.pumpAndSettle();

    expect(find.text('2000 kcal left'), findsOneWidget);
    expect(find.text('No meals logged today'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches to Scan tab', (tester) async {
    await tester.pumpWidget(const CalAiApp(initialRoute: AppRoutes.home));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    expect(find.text('Scan Food'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });
}
