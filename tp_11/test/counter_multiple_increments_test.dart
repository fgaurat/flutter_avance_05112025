import 'package:flutter_test/flutter_test.dart';

import 'package:tp_11/main.dart';

main() {
  testWidgets('Click sur le bouton d\'incrémentation 3 fois', (
    WidgetTester tester,
  ) async {
    // AAA: Arrange, Act, Assert
    await tester.pumpWidget(const MyApp());
    final btn = find.byTooltip("Increment");

    await tester.tap(btn);
    // await tester.pump();
    await tester.tap(btn);
    // await tester.pump();
    await tester.tap(btn);
    await tester.pump();
    expect(find.text('3'), findsOneWidget);
  });
}
