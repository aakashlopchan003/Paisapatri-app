import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paisa_patri/features/onboarding/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('shows the name, then moves on after two seconds',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(next: Scaffold(body: Text('next screen'))),
      ),
    );

    expect(find.text('PaisaPatri'), findsOneWidget);
    expect(find.text('next screen'), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('next screen'), findsOneWidget);
    expect(find.text('PaisaPatri'), findsNothing);
  });
}
