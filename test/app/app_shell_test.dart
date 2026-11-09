import 'package:flutter_test/flutter_test.dart';
import 'package:paisa_patri/app/app.dart';
import 'package:paisa_patri/app/app_shell.dart';

void main() {
  testWidgets('bottom bar opens each tab and can return home', (tester) async {
    await tester.pumpWidget(const PaisaPatriApp(home: AppShell()));
    expect(find.text('Spent this month'), findsOneWidget);

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    expect(find.text('Noodle house'), findsOneWidget);

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('Unknown merchant'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings will appear here.'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Spent this month'), findsOneWidget);
  });
}
