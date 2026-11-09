import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paisa_patri/features/review_inbox/presentation/screens/review_screen.dart';
import 'package:paisa_patri/features/review_inbox/presentation/widgets/review_item_card.dart';

void main() {
  testWidgets('shows three items with a reason and two buttons each',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: ReviewScreen()));

    expect(find.byType(ReviewItemCard), findsNWidgets(3));
    expect(find.text('Pick category'), findsNWidgets(3));
    expect(find.text('Skip'), findsNWidgets(3));
    expect(find.text('Unknown merchant'), findsOneWidget);
    expect(find.text('Remark was cut short'), findsOneWidget);
  });

  testWidgets('buttons do nothing yet and open no pop-up', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: ReviewScreen()));
    await tester.tap(find.text('Pick category').first);
    await tester.tap(find.text('Skip').first);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(ReviewItemCard), findsNWidgets(3));
  });
}
