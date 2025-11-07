import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tp_11/main.dart' as app;
import 'package:tp_11/models/todo.dart';
import 'fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test integration pull2refresh", (tester) async {
    final fake = FakeTodoService();
    app.runAppWithService(fake);
    await tester.pumpAndSettle();
    expect(find.text('A'), findsOneWidget);

    final list = find.byKey(const ValueKey('todo-list'));
    expect(list, findsOneWidget);

    fake.setData([Todo(id: 2, title: 'B', completed: false)]);

    await tester.drag(list, const Offset(0, 300));
    await tester.pump(); // start the frame
    await tester.pump(const Duration(milliseconds: 1300)); // finish the refresh

    await tester.pumpAndSettle();
    expect(find.text('A'), findsNothing);
    expect(find.text('B'), findsOneWidget);

    fake.setError(Exception('Simulated error'));
    await tester.drag(list, const Offset(0, 300));
    await tester.pump(); // start the frame
    await tester.pump(const Duration(milliseconds: 1300)); // finish the refresh
    await tester.pumpAndSettle();
    expect(find.textContaining('Error:'), findsOneWidget);

    fake.setData([Todo(id: 3, title: 'C', completed: false)]);
    await tester.tap(find.byKey(const ValueKey("retry-button")));
    await tester.pump(); // start the frame
    await tester.pump(const Duration(milliseconds: 1300)); // finish the refresh

    await tester.pumpAndSettle();
    expect(find.text('B'), findsNothing);
    expect(find.text('C'), findsOneWidget);
  });
}
