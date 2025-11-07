import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tp_11/models/todo.dart';
import 'package:tp_11/screens/todo_list_screen.dart';
import 'package:tp_11/services/todo_service.dart';

class MockTodoService extends Mock implements TodoService {}

main() {
  late MockTodoService service;

  // Helpers
  Todo todo(String title, {bool completed = false, int id = 0}) =>
      Todo(id: id, title: title, completed: completed);

  Widget app(Widget child) => MaterialApp(home: child);

  setUp(() {
    service = MockTodoService();
  });

  testWidgets('AFFICHE: loading puis data (2 items)', (tester) async {
    // On garde le Future en attente pour observer l’état loading au démarrage.

    final completer = Completer<List<Todo>>();

    when(() => service.getTodos()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(app(TodoListScreen(service: service)));

    // Loading visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // On délivre les données
    completer.complete([todo('A'), todo('B', completed: true)]);
    await tester.pump(); // applique la frame suite à la complétion

    // Liste visible
    expect(find.byKey(const ValueKey('todo-list')), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    // Icône checked pour 'B'
    expect(find.byIcon(Icons.check_box), findsOneWidget);

    verify(() => service.getTodos()).called(1);
  });

  testWidgets('AFFICHE: erreur puis Retry recharge et affiche data', (
    tester,
  ) async {
    // 1er appel: erreur
    when(
      () => service.getTodos(),
    ).thenAnswer((_) => Future.error(Exception('boom')));

    await tester.pumpWidget(app(TodoListScreen(service: service)));
    await tester.pump(); // passe de waiting -> error

    expect(find.textContaining('Error:'), findsOneWidget);
    expect(find.byKey(const ValueKey('retry-button')), findsOneWidget);

    // 2e appel (après Retry): retourne des données
    when(
      () => service.getTodos(),
    ).thenAnswer((_) async => [todo('X'), todo('Y')]);

    await tester.tap(find.byKey(const ValueKey('retry-button')));
    await tester.pump(); // applique setState du retry
    await tester.pump(); // applique complétion future (souvent un pump suffit)

    expect(find.byKey(const ValueKey('todo-list')), findsOneWidget);
    expect(find.text('X'), findsOneWidget);
    expect(find.text('Y'), findsOneWidget);

    verify(() => service.getTodos()).called(2); // 1 erreur + 1 retry
  });

  testWidgets('AFFICHE: état vide', (tester) async {
    when(() => service.getTodos()).thenAnswer((_) async => <Todo>[]);

    await tester.pumpWidget(app(TodoListScreen(service: service)));
    await tester.pump();

    expect(find.text('No todos available'), findsOneWidget);
    verify(() => service.getTodos()).called(1);
  });

  testWidgets('PULL-TO-REFRESH: rappelle le service et met à jour la liste', (
    tester,
  ) async {
    // initial: A
    when(() => service.getTodos()).thenAnswer((_) async => [todo('A')]);

    await tester.pumpWidget(app(TodoListScreen(service: service)));
    await tester.pump();

    expect(find.text('A'), findsOneWidget);

    // refresh doit renvoyer B
    when(() => service.getTodos()).thenAnswer((_) async => [todo('B')]);

    // En état data, on drag la liste
    final list = find.byKey(const ValueKey('todo-list'));
    expect(list, findsOneWidget);

    await tester.drag(list, const Offset(0, 300)); // pull-down
    await tester.pump(); // démarre l’anim
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle(); // fin anim + future

    expect(find.text('B'), findsOneWidget);
    expect(find.text('A'), findsNothing);

    verify(() => service.getTodos()).called(2); // initial + refresh
  });
}
