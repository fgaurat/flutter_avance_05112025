import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp_11/main.dart';

main() {
  testWidgets('affiche le titre et 0 au démarrage', (
    WidgetTester tester,
  ) async {
    // AAA: Arrange, Act, Assert
    await tester.pumpWidget(const MyApp());
    expect(find.text("Flutter Demo Home Page"), findsOneWidget);
    expect(find.byKey(ValueKey('counter-text')), findsOneWidget);

    final counterText = tester.widget<Text>(find.byKey(ValueKey('counter-text')));
    expect(counterText.data, '0');
  });
}
