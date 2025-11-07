import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp_11/main.dart';

main() {
  testWidgets('Click sur le bouton d\'incrémentation', (
    WidgetTester tester,
  ) async {
    // AAA: Arrange, Act, Assert
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
