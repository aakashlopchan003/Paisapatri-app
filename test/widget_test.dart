import 'package:flutter_test/flutter_test.dart';
import 'package:paisa_patri/app/app.dart';

void main() {
  testWidgets('shows the app name', (tester) async {
    await tester.pumpWidget(const PaisaPatriApp());
    // The real app starts at the splash, which shows the name.
    expect(find.text('PaisaPatri'), findsOneWidget);
  });
}
