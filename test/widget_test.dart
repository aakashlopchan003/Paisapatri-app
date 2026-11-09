import 'package:flutter_test/flutter_test.dart';
import 'package:paisa_patri/main.dart';

void main() {
  testWidgets('shows the app name', (tester) async {
    await tester.pumpWidget(const PaisaPatriApp());
    expect(find.text('PaisaPatri'), findsOneWidget);
  });
}
